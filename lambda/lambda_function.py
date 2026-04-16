import json
import random
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    try:
        # 1. Initialize parameters with defaults
        data = {}

        # 2. Handle GET (Query String Parameters)
        if event.get('queryStringParameters'):
            data.update(event['queryStringParameters'])

        # 3. Handle POST (Stringified JSON Body)
        if event.get('body'):
            try:
                body_data = json.loads(event['body'])
                data.update(body_data)
            except json.JSONDecodeError:
                pass # Fallback if body isn't valid JSON

        # 4. Extract and cast to integers (API Gateway sends everything as strings)
        min_val = int(data.get('min', 1))
        max_val = int(data.get('max', 100))

        # 5. Validation
        if min_val > max_val:
            raise ValueError("Min cannot be greater than Max.")

        # 6. Generate Value
        result = random.randint(min_val, max_val)

        # 7. MUST return this specific format for API Gateway REST API
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*' # Required for CORS/Frontend access
            },
            'body': json.dumps({
                'random_value': result,
                'min': min_val,
                'max': max_val
            })
        }

    except ValueError as e:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'Invalid Input', 'message': str(e)})
        }
    except Exception as e:
        logger.error(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Internal Server Error'})
        }
    
    
# How to Test:
# - GET: https://api-id.execute-api.region.amazonaws.com
# - POST: Send a JSON body like {"min": 5, "max": 50} to the endpoint.