FROM python:3.11-slim

WORKDIR /
COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]