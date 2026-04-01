FROM python:3.9-slim AS builder
WORKDIR /build
COPY requirements.txt .

RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install --prefix=/install -r requirements.txt && \
    pip3 install --prefix=/install gunicorn

FROM python:3.9-slim
WORKDIR /code
COPY --from=builder /install /usr/local

COPY . .
ENV REDIS_ADDRESS=redis \
    REDIS_PORT=6379
EXPOSE 8000

CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:8000", "home:app"]
