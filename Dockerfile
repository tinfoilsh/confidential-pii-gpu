# GPU image for the OpenAI Privacy Filter (opf) token-classification model.
# Model weights are mounted as a verified modelwrap (MWP) read-only
# filesystem at boot — no HuggingFace download or egress required.
FROM pytorch/pytorch:2.6.0-cuda12.6-cudnn9-runtime

RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

# torch is preinstalled in the pytorch/pytorch base image; opf's torch dep
# is already satisfied, so pip skips it.
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

COPY server.py /app/server.py

WORKDIR /app

ENV OPF_DEVICE=cuda

EXPOSE 8001

CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8001"]
