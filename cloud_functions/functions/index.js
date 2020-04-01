const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);

var newData;
exports.myTrigger = functions.firestore.document('Messages/{messageId}').onCreate(async (snapshot, context) => {
       //

       if (snapshot.empty) {
              console.log('No Devices');
              return;
       }
       var tokens = ['eW6KfpRWJt8:APA91bHGi_-dYbdrkm8Lot2NL95ouB5ERHC3YZQHBRyyLScgRnEVZ0w6ma0jgJ4SHF6Z2egdK03nZMSHKJsC54meJgNGfQ8GyvDQn-rvNUA-aD305cWBspAiMwo-6F-S6UnxbPf77ubJ'];
       newData = snapshot.data();
       var payLoad = {
              notification: {
                     body: 'Body Push',
                     title: 'Cloud function',
                     sound: 'default',
              },
              data: {
                     click_action: 'FLUTTER_NOTIFICATION_CLICK',
                     message: newData.message
              }
       }
       try {
              const response = await admin.messaging().sendToDevice(tokens, payLoad);
              console.log('Notification Send succesfuully');
       } catch (err) {
              console.log('Error sending notification');

       }
});