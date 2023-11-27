import azure.functions as func
from azure.storage.blob import BlobClient
from azure.identity import  DefaultAzureCredential
import logging

BASENAME = "tumworkshop0"

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)


@app.route(route="http-trigger")
def http_trigger(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    name = req.params.get('name')
    if not name:
        try:
            req_body = req.get_json()
        except ValueError:
            pass
        else:
            name = req_body.get('name')

    if name:
        return func.HttpResponse(f"Hello, {name}. This HTTP triggered function executed successfully.")
    else:
        return func.HttpResponse(
             "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response.",
             status_code=200
        )


# Part 3:

# setup credentials to access storage account
CREDENTIAL = DefaultAzureCredential()

# Blob URL
BLOB_URL = f"https://{BASENAME}.blob.core.windows.net/container1/sample.txt"


# Define a new function that reads a blob from the storage account 
# and returns it as an HTTP response.

# TODO


@app.route(route="get-file")
def get_file(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python get_file function processed a request.')

    blob_client = BlobClient.from_blob_url(BLOB_URL, CREDENTIAL)
    download_stream = blob_client.download_blob()

    logging.info(download_stream.readall())

    return func.HttpResponse(
        download_stream.readall(),
        status_code=200
    )