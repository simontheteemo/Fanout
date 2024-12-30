const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
    console.log('Processing order event:', JSON.stringify(event, null, 2));
    
    for (const record of event.Records) {
        try {
            const body = JSON.parse(record.body);
            const message = JSON.parse(body.Message);
            
            console.log('Processing order:', message);
            
            // Save to DynamoDB
            await saveOrder(message);
            
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

async function saveOrder(order) {
    const timestamp = new Date().toISOString();
    
    const params = {
        TableName: process.env.DYNAMODB_TABLE,
        Item: {
            orderId: order.orderId || `ORDER-${Date.now()}`,
            timestamp: timestamp,
            ...order,
            status: 'RECEIVED'
        }
    };

    console.log('Saving order to DynamoDB:', params);
    await dynamodb.put(params).promise();
    console.log('Order saved successfully');
}