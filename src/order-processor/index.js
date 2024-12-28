// src/order-processor/index.js
exports.handler = async (event, context) => {
    console.log('Processing order event:', JSON.stringify(event, null, 2));
    
    for (const record of event.Records) {
        const body = JSON.parse(record.body);
        const message = JSON.parse(body.Message);
        
        console.log('Processing order:', message);
        
        // Add your order processing logic here
        await processOrder(message);
    }
    
    return {
        statusCode: 200,
        body: JSON.stringify({ message: 'Orders processed successfully' })
    };
};

async function processOrder(order) {
    // Simulate order processing
    console.log(`Processing order ID: ${order.orderId}`);
    await new Promise(resolve => setTimeout(resolve, 100));
}