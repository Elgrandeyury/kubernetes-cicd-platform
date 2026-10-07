FROM python:3.13-slim AS builder

WORKDIR /build
COPY app/requirements.txt .
RUN pip install --no-cache-dir --upgrade \
      "setuptools>=78.1.1" \
      "urllib3>=2.8.0" \
      "msgpack>=1.2.1" && \
    pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.13-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8080

RUN pip install --no-cache-dir --upgrade \
      "setuptools>=78.1.1" \
      "urllib3>=2.8.0" \
      "msgpack>=1.2.1" && \
    groupadd --system app && \
    useradd --system --gid app --create-home app

WORKDIR /app
COPY --from=builder /install /usr/local
COPY app/main.py ./main.py

USER app
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8080/health/live')" || exit 1

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "2", "--threads", "2", "--access-logfile", "-", "main:app"]
