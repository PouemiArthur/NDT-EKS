FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

RUN pip install pytest pytest-flask

COPY pjrapp.py .

EXPOSE 5000

CMD ["python", "pjrapp.py"]
