import json
import boto3
import uuid
import logging
import os
from datetime import datetime


logger = logging.getLogger()
logger.setLevel(logging.INFO)

table_name = os.environ["DYNAMO_DB"]
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    logger.info("EVENT RECEIVED: %s", json.dumps(event))

    try:
        
        body = json.loads(event.get("body", "{}"))
        logger.info("Parsed body: %s", json.dumps(body))

        
        reservation_id = str(uuid.uuid4())
        timestamp = datetime.utcnow().isoformat()

        
        item = {
            "user_id": body.get("user_id", "anonymous"),
            "reservation_id": reservation_id,
            "name": body.get("name"),
            "phone": body.get("phone"),
            "date": body.get("date"),
            "time": body.get("time"),
            "guests": body.get("guests"),
            "createdAt": timestamp
        }

       
        logger.info("Putting item into DynamoDB: %s", json.dumps(item))

        
        table.put_item(Item=item)

        
        response = {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*"
            },
            "body": json.dumps({
                "message": "Reservation successful",
                "reservationId": reservation_id
            })
        }

        logger.info("SUCCESS RESPONSE: %s", json.dumps(response))
        return response

    except Exception as e:
        logger.error("ERROR: %s", str(e), exc_info=True)

        return {
            "statusCode": 500,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*"
            },
            "body": json.dumps({
                "message": "Internal server error",
                "error": str(e)
            })
        }
