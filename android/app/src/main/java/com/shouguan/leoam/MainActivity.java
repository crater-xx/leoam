package com.shouguan.leoam;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;


import android.app.Activity;
import android.database.Cursor;
import android.database.sqlite.SQLiteException;
import android.net.Uri;
import android.os.Bundle;
import android.telephony.SmsMessage;
import android.util.EventLog;
import android.util.Log;
import android.widget.ScrollView;
import android.widget.TableLayout;
import android.widget.TextView;
import android.telephony.SmsMessage;

import org.json.JSONException;
import org.json.JSONObject;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.shouguan.leoam/sms";
    private static final String EVENT_CHANNEL = "com.shouguan.leoax/onNewSMS";
    private static final String SMS_RECEIVED = "android.provider.Telephony.SMS_RECEIVED";
    private static final String TAG = "sms plgin";
    private BroadcastReceiver smsReceiver;
    final String SMS_URI_ALL = "content://sms/";
    final String SMS_URI_INBOX = "content://sms/inbox";
    final String SMS_URI_SEND = "content://sms/sent";
    final String SMS_URI_DRAFT = "content://sms/draft";
    final String SMS_URI_OUTBOX = "content://sms/outbox";
    final String SMS_URI_FAILED = "content://sms/failed";
    final String SMS_URI_QUEUED = "content://sms/queued";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("getAllSms")) {
                                ArrayList<String> alls = getAllSms();
                                result.success(alls);
                            }else if(call.method.equals("initXMLYSdk")){

                            }
                        });
        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),EVENT_CHANNEL)
                .setStreamHandler(new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object arguments, EventChannel.EventSink eventSink) {
                        Log.d(TAG,"add listener");
                        smsReceiver = createChargingStateChangeReceiver(eventSink);
                        registerReceiver(smsReceiver, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
                    }

                    @Override
                    public void onCancel(Object arguments) {
                        Log.d(TAG,"cancelling listener");
                        unregisterReceiver(smsReceiver);
                        smsReceiver = null;
                    }
                });
    }

    private BroadcastReceiver createChargingStateChangeReceiver(final EventChannel.EventSink events) {
        return new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                if (intent != null && SMS_RECEIVED.equals(intent.getAction()) && Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    final Bundle pudsBundle = intent.getExtras();
                    final Object[] pdus = (Object[]) pudsBundle.get("pdus");
                    SmsMessage[] msgs = new SmsMessage[pdus.length];
                    ArrayList<String>  all = new ArrayList<String>();
                    String format = intent.getStringExtra("format");
                    for (int i=0;i<pdus.length; i++) {
                        msgs[i] = SmsMessage.createFromPdu((byte[])pdus[i],format);
                        try{
                            JSONObject sms = new JSONObject();
                            sms.put("sender",msgs[i].getDisplayOriginatingAddress());
                            sms.put("person",msgs[i].getMessageBody());
                            sms.put("body",msgs[i].getDisplayMessageBody());
                            long date=msgs[i].getTimestampMillis();
                            Date timeDate=new Date(date);
                            SimpleDateFormat simpleDateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            String time=simpleDateFormat.format(timeDate);
                            sms.put("date",time);
                            sms.put("status",msgs[i].getStatus());
                            all.add(sms.toString());
                        } catch (JSONException ex){
                            Log.d("add sms",ex.getMessage());
                        }
                    }
                    events.success(all);
                }
            }
        };
    }

    public void initXMLASdk(String appKey,String appSecret,String packId){

    }


    @SuppressLint("LongLogTag")
    public ArrayList<String> getAllSms() {
        ArrayList<String>  all = new ArrayList<String>();
        try {
            Uri uri = Uri.parse(SMS_URI_ALL);
            String[] projection = new String[] { "_id", "address", "person", "body", "date", "type","read","status" };
            Cursor cur = getContentResolver().query(uri, projection, null, null, "date desc");		// 获取手机内部短信

            if (cur.moveToFirst()) {
                int index_Address = cur.getColumnIndex("address");
                int index_Person = cur.getColumnIndex("person");
                int index_Body = cur.getColumnIndex("body");
                int index_Date = cur.getColumnIndex("date");
                int index_Type = cur.getColumnIndex("type");
                int index_Read = cur.getColumnIndex("read");
                int index_Status = cur.getColumnIndex("status");
                do {

                    String strAddress = cur.getString(index_Address);
                    int intPerson = cur.getInt(index_Person);
                    String strbody = cur.getString(index_Body);
                    long longDate = cur.getLong(index_Date);
                    int intType = cur.getInt(index_Type);
                    int intRead = cur.getInt(index_Read);
                    int intStatus = cur.getInt(index_Status);

                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
                    Date d = new Date(longDate);
                    String strDate = dateFormat.format(d);

                    String strType = "";
                    if (intType == 1) {
                        strType = "接收";
                    } else if (intType == 2) {
                        strType = "发送";
                    } else {
                        strType = "null";
                    }
                    try{
                        JSONObject sms = new JSONObject();
                        sms.put("addres",strAddress);
                        sms.put("person",intPerson);
                        sms.put("body",strbody);
                        sms.put("date",strDate);
                        sms.put("type",strType);
                        sms.put("read",intRead);
                        sms.put("status",intStatus);

                        all.add(sms.toString());
                    } catch (JSONException ex){
                        Log.d("add sms",ex.getMessage());
                    }

                } while (cur.moveToNext());

                if (!cur.isClosed()) {
                    cur.close();
                    cur = null;
                }
            } else {

            } // end if
        } catch (SQLiteException ex) {
            Log.d("SQLiteException in getSmsInPhone", ex.getMessage());
        }
        return all;
    }
}
