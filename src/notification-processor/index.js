// src/notification-processor/index.js
const AWS = require('aws-sdk');
const ssm = new AWS.SSM();

// Cache object outside the handler to persist across invocations
let configCache = {
    value: null,
    timestamp: 0
};

// Cache TTL in milliseconds (e.g., 5 minutes)
const CACHE_TTL = 5 * 60 * 1000;

async function getConfig() {
    const now = Date.now();
    
    // Return cached config if it's still valid
    if (configCache.value && (now - configCache.timestamp) < CACHE_TTL) {
        console.log('Using cached config');
        return configCache.value;
    }

    try {
        console.log('Fetching fresh config from SSM');
        const params = {
            Name: '/fanout-demo/notification/config',
            WithDecryption: true
        };
        
        const result = await ssm.getParameter(params).promise();
        const config = JSON.parse(result.Parameter.Value);
        
        // Update cache
        configCache = {
            value: config,
            timestamp: now
        };
        
        return config;
    } catch (error) {
        console.error('Error fetching config from SSM:', error);
        // If we have stale cache, use it as fallback
        if (configCache.value) {
            console.log('Using stale cache as fallback');
            return configCache.value;
        }
        throw new Error('Failed to load configuration from SSM');
    }
}

exports.handler = async (event, context) => {
    let config;
    
    try {
        // Get config once per Lambda invocation
        config = await getConfig();
        
        for (const record of event.Records) {
            const body = JSON.parse(record.body);
            const message = JSON.parse(body.Message);
            
            await sendNotification(message, config);
        }
        
        return {
            statusCode: 200,
            body: JSON.stringify({ message: 'Notifications processed successfully' })
        };
    } catch (error) {
        console.error('Error in notification processing:', error);
        throw error;
    }
};

async function sendNotification(notification, config) {
    console.log('Sending notification with config settings:', {
        configPresent: !!config,
        notificationType: notification.type || 'default'
    });
    
    await new Promise(resolve => setTimeout(resolve, 100));
}