package com.gcamp.artifact;

import android.os.AsyncTask;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Calendar;
import java.util.Random;
import java.util.Scanner;
import java.util.concurrent.ExecutionException;

public class Hint {
    private static String key = "";
    private static float angle = 0;
    private static double lat = 0, lng = 0;
    private static int id = -1, level = -1;
    final static String[][] keyTable = new String[6][6];
    final static int[][] order = new int[6][6];
    final static double[] gameLat = new double[6] ;
    final static double[] gameLng = new double[6];

    /* 設定小隊名和截止時間 */
    final static String[] teamName = new String[] {"拉拉克普托", "布魯斯韋恩", "歐奇牙比", "紅爾莫特", "普林斯小碧", "凱斯庫瑞"};
    final static int deadline = 15 * 3600 + 45 * 60;

    private static Random rand = new Random();

    public static void buildDB() {
        try {
            HandleDatabaseTask handleDatabaseTask = new HandleDatabaseTask();
            handleDatabaseTask.execute();
            handleDatabaseTask.get();
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
        }
    }

    public static boolean isActive() {
        if (id == -1 && level == -1) {
            return false;
        } else {
            return true;
        }
    }

    public static void setKey(String key) {
        Hint.key = key;
        buildDB();
    }

    public static void setAngle(float angle) {
        Hint.angle = angle;
    }

    public static void setLocation(double lat, double lng) {
        Hint.lat = lat;
        Hint.lng = lng;
    }

    public static String getMessage() {
        if (key.equals("")) {
            return "Point Me";
        }
        if (key.equals("0000000")) {
            if (keyTable[0][0] != null) {
                return "連線成功";
            } else {
                return "連線失敗";
            }
        }

        id = -1;
        level = -1;
        for (int i = 0; i < keyTable.length; i++) {
            for (int j = 0; j < keyTable[i].length; j++) {
                if (key.equals(keyTable[i][j])) {
                    id = i;
                    level = j;
                }
            }
        }
        if (id == -1 && level == -1) {
            return "錯誤";
        }

        String message = teamName[id] + " ";
        for (int i = 0; i < level + 1; i++) {
            message += "★";
        }
        for (int i = level + 1; i < 6; i++) {
            message += "☆";
        }
        message += "\n剩餘時間 " + remainingTime() + "\n";
        if (level == 0 || level == 3 || level == 5) {
            message += "距離 " + (int) distance() + " 公尺";
        } else if (level == 1 || level == 4) {
            message += "距離 ";
            int far = Math.min((int) (distance() / 100), 10);
            for (int i = 0; i < far; i++) {
                message += "*";
            }
        } else if (level == 2) {
            if (distance() < 10) {
                message += "抵達";
            }
        }

        return message;
    }

    public static float getAngle() {
        if (id == -1 && level == -1) {
            return 0;
        }

        double Dlat = gameLat[order[id][level]] - lat;
        double Dlng = gameLng[order[id][level]] - lng;
        float at = (float) Math.toDegrees(Math.atan2(Dlng, Dlat));
        float angle = at - Hint.angle;

        if (level == 3) {
            angle += (rand.nextInt(45) - 22);
        } else if (level == 4) {
            angle += (rand.nextInt(91) - 45);
        } else if (level == 5) {
            angle += rand.nextInt(360);
        }

        return angle;
    }

    private static String remainingTime() {
        Calendar calendar = Calendar.getInstance();
        int now = calendar.get(Calendar.HOUR_OF_DAY) * 3600 + calendar.get(Calendar.MINUTE) * 60 + calendar.get(Calendar.SECOND);
        now = Math.max(deadline - now, 0);
        return String.format("%02d:%02d:%02d", now / 3600, (now % 3600) / 60, now % 60);
    }

    private static double distance() {
        return distance(gameLat[order[id][level]], gameLng[order[id][level]], Hint.lat, Hint.lng);
    }
    private static double distance(double lat1, double lng1, double lat2, double lng2) {
        return 111111 * Math.sqrt(Math.pow(lat1 - lat2, 2) + Math.pow(lng1 - lng2, 2));
    }
}

class HandleDatabaseTask extends AsyncTask<URL, Integer, Boolean> {
    @Override
    protected Boolean doInBackground(URL... params) {
        try {
            //連接資料庫，取得資料
            URL url = new URL("http://140.116.47.91/Gcamp106/json.php?table=keyTable" );
            URL url2 = new URL("http://140.116.47.91/Gcamp106/json.php?table=locationTable" );
            HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
            HttpURLConnection urlConnection2 = (HttpURLConnection) url2.openConnection();
            Scanner in = new Scanner(urlConnection.getInputStream());
            Scanner in2 = new Scanner(urlConnection2.getInputStream());
            in.hasNextLine();
            in2.hasNextLine();
            JSONArray jsonArray = new JSONArray(in.nextLine());
            JSONArray jsonArray2 = new JSONArray(in2.nextLine());

            int k = 0;
            for (int i = 0; i < 6; i++) {
                for (int j = 0; j < 6; j++) {
                    if (k > 35) {
                        k = 0;
                    }
                    Hint.keyTable[i][j] = jsonArray.getJSONObject(k).getString("password");
                    Hint.order[i][j] = jsonArray.getJSONObject(k).getInt("orders");
                    k++;
                }
                Hint.gameLat[i] = jsonArray2.getJSONObject(i).getDouble("lat");
                Hint.gameLng[i] = jsonArray2.getJSONObject(i).getDouble("log");
            }

            in.close();
            in2.close();
            urlConnection.disconnect();
            urlConnection2.disconnect();
        } catch (IOException | JSONException e) {
            Log.d("Eric", "doInBackground: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }
}
