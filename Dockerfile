# Inventory fixture: multi-stage build, registry mirror build arg and a digest-pinned runtime.
ARG DOCKER_HUB_MIRROR=
FROM ${DOCKER_HUB_MIRROR}python:3.12-slim@sha256:12316debbfb86890f6b2d825820612741ba527ad5a44e3902759141d572bfe8f AS builder
WORKDIR /app
COPY dependencies/pipenv/Pipfile dependencies/pipenv/Pipfile.lock ./
RUN pip install --no-cache-dir pipenv && pipenv requirements > requirements.txt \
    && pip install --no-cache-dir --target /deps -r requirements.txt

FROM builder AS tests
RUN python -c "import httpx, yaml"

FROM gcr.io/distroless/python3-debian12:nonroot@sha256:7d1042ce588ab97019fe95c24ffca7bc5a82ccdac572511d5e09bda4435c89c5
COPY --from=builder /deps /deps
COPY app.py /app/app.py
ENV PYTHONPATH=/deps
CMD ["/app/app.py"]
