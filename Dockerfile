ARG AIDO_REGISTRY
FROM ${AIDO_REGISTRY}/duckietown/aido-base-python3:daffy-aido4

ARG PIP_INDEX_URL
ENV PIP_INDEX_URL=${PIP_INDEX_URL}


COPY requirements.* ./
RUN pip install --use-feature=2020-resolver -r requirements.resolved
RUN pip list

COPY . .

RUN PYTHON_PATH=. python3 -c "import minimal_agent"

ENTRYPOINT ["python3", "minimal_agent.py"]
