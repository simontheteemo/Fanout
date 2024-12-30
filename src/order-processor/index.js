const AWS = require('aws-sdk');
const _ = require('lodash');
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
    console.log('Processing order event:', JSON.stringify(event, null, 2));
    
    for (const record of event.Records) {
        try {
            const body = JSON.parse(record.body);
            const message = JSON.parse(body.Message);
            
            console.log('Processing order:', message);
            
            // Example using lodash to transform the order data
            const transformedOrder = _.transform(message, (result, value, key) => {
                result[_.toUpper(key)] = value;
            }, {});
            
            await saveOrder(transformedOrder);
            
        } catch (error) {
            console.error('Error processing order:', error);
            throw error;
        }
    }
    
    return {
        statusCode: 200,
        body: JSON.stringify({ message: 'Orders processed successfully' })
    };
};

async function saveOrder(message) {
    const params = {
        TableName: process.env.DYNAMODB_TABLE,
        Item: {
            orderId: _.get(message, 'ORDERID', `ORDER-${Date.now()}`),
            timestamp: new Date().toISOString(),
            ...message,
            status: 'RECEIVED'
        }
    };

    console.log('Saving to DynamoDB:', params);
    await dynamodb.put(params).promise();
    console.log('Order saved successfully');
}