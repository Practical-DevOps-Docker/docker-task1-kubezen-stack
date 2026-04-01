FROM python:3.9-slim AS builder
WORKDIR /code
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt gunicorn

FROM python:3.9-slim
WORKDIR /code
COPY --from=builder /install /usr/local
COPY . .
ENV REDIS_ADDRESS=redis \
    REDIS_PORT=6379
EXPOSE 8000

CMD ["gunicorn", "app.main:app", "--bind", "0.0.0.0:8000"]
