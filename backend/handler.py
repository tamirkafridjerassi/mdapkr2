import json
import boto3
import os

dynamodb = boto3.resource('dynamodb')

crew_table = dynamodb.Table(os.environ['CREW_TABLE'])
missions_table = dynamodb.Table(os.environ['MISSIONS_TABLE'])
availability_table = dynamodb.Table(os.environ['AVAILABILITY_TABLE'])

def lambda_handler(event, context):
    print("=== EVENT ===")
    print(json.dumps(event))

    method = event.get("requestContext", {}).get("http", {}).get("method")
    path = event.get("rawPath") or event.get("path", "")
    print(f"Method: {method}, Path: {path}")

    # Handle preflight CORS
    if method == "OPTIONS":
        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "*",
                "Access-Control-Allow-Methods": "OPTIONS,GET,POST"
            },
            "body": ""
        }

    try:
        if method == "GET" and "/crew" in path:
            response = crew_table.scan()
            return respond(200, response['Items'])

        elif method == "GET" and "/missions" in path:
            response = missions_table.scan()
            return respond(200, response['Items'])

        elif method == "GET" and "/availability" in path:
            response = availability_table.scan()
            return respond(200, response['Items'])

        elif method == "POST" and "/crew" in path:
            body = json.loads(event.get("body") or "{}")
            print("Parsed crew POST body:", body)
            crew_table.put_item(Item=body)
            return respond(200, {"message": "Crew added"})

        elif method == "POST" and "/missions" in path:
            body = json.loads(event.get("body") or "{}")
            print("Parsed mission POST body:", body)

            # Mission update mode
            if "name" in body and "date" in body and "status" in body:
                missions_table.update_item(
                    Key={"name": body["name"]},
                    UpdateExpression=f"SET #d = :val",
                    ExpressionAttributeNames={"#d": body["date"]},
                    ExpressionAttributeValues={":val": body["status"]}
                )
                return respond(200, {"message": "Mission status updated"})

            # New mission creation
            elif "name" in body and "region" in body and "type" in body:
                missions_table.put_item(Item=body)
                return respond(200, {"message": "Mission added"})

            else:
                return respond(400, {"error": "Invalid mission data"})

        elif method == "POST" and "/availability" in path:
            body = json.loads(event.get("body") or "{}")
            print("Parsed availability POST body:", body)
            availability_table.put_item(Item=body)
            return respond(200, {"message": "Availability updated"})

        else:
            print("No route matched.")
            return respond(404, {"error": "Not found"})

    except Exception as e:
        print("Error occurred:", str(e))
        return respond(500, {"error": str(e)})

def respond(status, body):
    return {
        "statusCode": status,
        "headers": {
            "Access-Control-Allow-Origin": "*",
            "Content-Type": "application/json"
        },
        "body": json.dumps(body)
    }
