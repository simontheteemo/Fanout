// src/notification-processor/index.js
exports.handler = async (event, context) => {
    console.log('Processing notification event:', JSON.stringify(event, null, 2));
    
    for (const record of event.Records) {
        const body = JSON.parse(record.body);
        const message = JSON.parse(body.Message);
        
        console.log('Sending notification:', message);
        
        // Add your notification logic here
        await sendNotification(message);
    }
    
    return {
        statusCode: 200,
        body: JSON.stringify({ message: 'Notifications sent successfully' })
    };
};

async function sendNotification(notification) {
    // Simulate notification sending
    console.log(`Sending notification: ${notification.message}`);
    await new Promise(resolve => setTimeout(resolve, 100));
}