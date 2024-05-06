package com.gcamp.artifact;

import android.Manifest;
import android.app.Service;
import android.content.pm.PackageManager;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity implements View.OnClickListener, LocationListener, SensorEventListener {

    TextView textView;
    ImageView imageView;
    EditText editText;
    Button button;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        /* 取得元件 */
        textView = (TextView) findViewById(R.id.textView);
        imageView = (ImageView) findViewById(R.id.imageView);
        editText = (EditText) findViewById(R.id.editText);
        button = (Button) findViewById(R.id.button);
        /* 監聽按鈕 */
        button.setOnClickListener(this);

        /* 請求使用者同意授權高精度定位存取功能 */
        ActivityCompat.requestPermissions(this, new String[] {Manifest.permission.ACCESS_FINE_LOCATION}, 1);

        /* 取得系統感測器服務 */
        SensorManager senMgr = (SensorManager) getSystemService(Service.SENSOR_SERVICE);
        /* 取得磁力感測器及重力感測器 */
        Sensor mSensor = senMgr.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);
        Sensor aSensor = senMgr.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        /* 註冊欲監聽的感測器 */
        senMgr.registerListener(this, mSensor, SensorManager.SENSOR_DELAY_GAME);
        senMgr.registerListener(this, aSensor, SensorManager.SENSOR_DELAY_GAME);
    }

    @Override
    protected void onResume() {
        super.onResume();

        /* 取得系統定位服務 */
        LocationManager locMgr = (LocationManager) getSystemService(Service.LOCATION_SERVICE);
        /* 設定位置更新參數 */
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
            locMgr.requestLocationUpdates(LocationManager.GPS_PROVIDER, 1000, 1, this);
            locMgr.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 1000, 1, this);
        }
    }

    @Override
    public void onClick(View v) {
        /* 輸入金鑰 */
        Hint.setKey(editText.getText().toString());
    }

    float[] mValues = null, aValues = null;

    @Override
    public void onSensorChanged(SensorEvent event) {
        /* 如果為磁力感測器，則取得數值並存到 mValues */
        if (event.sensor.getType() == Sensor.TYPE_MAGNETIC_FIELD) {
            mValues = event.values;
        }
        /* 如果為重力感測器，則取得數值並存到 aValues */
        if (event.sensor.getType() == Sensor.TYPE_ACCELEROMETER) {
            aValues = event.values;
        }

        if (mValues != null && aValues != null) {
            /* 計算方位角 */
            float[] Rotation = new float[9];
            float[] degree = new float[3];
            SensorManager.getRotationMatrix(Rotation, null, aValues, mValues);
            SensorManager.getOrientation(Rotation, degree);
            float angle = (float) Math.toDegrees(degree[0]);
            /* 輸入方位角 */
            Hint.setAngle(angle);
        }

        /* 顯示線索 */
        textView.setText(Hint.getMessage());
        /* 顯示指引方向 */
        imageView.setRotation(Hint.getAngle());

        /* 是否點亮魔杖 */
        if (Hint.isActive()) {
            imageView.setImageResource(R.drawable.wand_active);
        } else {
            imageView.setImageResource(R.drawable.wand);
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {

    }

    @Override
    public void onLocationChanged(Location location) {
        /* 取得經緯度 */
        double lat = location.getLatitude();
        double lng = location.getLongitude();
        /* 輸入位置 */
        Hint.setLocation(lat, lng);
    }

    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {

    }

    @Override
    public void onProviderEnabled(String provider) {

    }

    @Override
    public void onProviderDisabled(String provider) {

    }
}
