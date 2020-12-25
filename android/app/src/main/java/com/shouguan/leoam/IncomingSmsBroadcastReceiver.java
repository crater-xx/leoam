package com.shouguan.leoam;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.telephony.SmsMessage;

//sms 广播接收者
public class IncomingSmsBroadcastReceiver extends BroadcastReceiver {
    private static final String SMS_RECEIVED = "android.provider.Telephony.SMS_RECEIVED";
    @Override
    public void onReceive(final Context context, final Intent intent) {
        if (intent != null && SMS_RECEIVED.equals(intent.getAction())) {
            final SmsMessage smsMessage = extractSmsMessage(intent);
            processMessage(context, smsMessage);
        }
    }
    private SmsMessage extractSmsMessage(final Intent intent) {
        final Bundle pudsBundle = intent.getExtras();
        SmsMessage msgs = null;
        final Object[] pdus = (Object[]) pudsBundle.get("pdus");
        for (int i=0;i<pdus.length; i++) {
          //  msgs = SmsMessage.createFromPdu((byte[])pdus[i],"%s");
        }
        return msgs;
    }
    private void processMessage(final Context context, final SmsMessage smsMessage) {
        //TODO: Send message to event channel
        /*
        if(smsMessage.getMessageBody()!=null){
            result.success(smsMessage.getMessageBody());
        }else{
            result.error("Error", "Sms not found", null);
        }
         */
    }
}

