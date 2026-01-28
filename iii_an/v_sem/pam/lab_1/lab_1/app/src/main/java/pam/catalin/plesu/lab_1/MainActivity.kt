package pam.catalin.plesu.lab_1

import android.app.DatePickerDialog
import androidx.appcompat.app.AppCompatActivity
import android.widget.*
import android.os.Bundle
import android.view.View
import java.util.*
import kotlin.random.Random

var calendar: Calendar = Calendar.getInstance();
var mmm = calendar.get(Calendar.MONTH);
var ddd = calendar.get(Calendar.DATE);
var yyy = calendar.get(Calendar.YEAR);

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }

    fun openDatePicker(view: View) {
        var calendar: Calendar = Calendar.getInstance();
        val birthDate = findViewById<TextView>(R.id.textViewBD);
        val age = findViewById<TextView>(R.id.textViewAGE);

        var cyy = calendar.get(Calendar.YEAR);
        var cmm = calendar.get(Calendar.MONTH);
        var cdd = calendar.get(Calendar.DATE);

        DatePickerDialog(this,
            DatePickerDialog.OnDateSetListener{datePicker, yy, mm, dd ->
                ddd = dd; mmm = mm; yyy = yy;

                yyy = cyy - yyy;
                if(mm<=cmm){
                    mmm = cmm - mmm;
                }else{
                    mmm = 12 - mmm;
                    yyy -= 1;
                }
                if(ddd<=cdd){
                    ddd = cdd - ddd;
                }else{
                    ddd = 31 - ddd;
                }
                if(dd>=cdd && mm >=cmm && yy >= cyy){
                    ddd = cdd; mmm = cmm; yyy = cyy;
                    birthDate.text = "Invalid date"
                    age.text = "You still haven't been born";
                }else{
                 birthDate.text = "Birth date: ${if(dd<10) 0 else ""}$dd.${if(mm+1<10) 0 else ""}${mm+1}.$yy";
                    age.text = "Your age is: ${yyy} Years; ${mmm} Months; ${ddd} Days";
                    ddd = dd; mmm = mm; yyy = yy;
                }
            }, yyy, mmm, ddd
       ).show();
    }

    fun clearCalendarDate(view: View) {
        val birthDate = findViewById<TextView>(R.id.textViewBD);
        val age = findViewById<TextView>(R.id.textViewAGE);
        birthDate.text = "Birth Date";
        age.text = "Your age:";
        yyy = calendar.get(Calendar.YEAR);
        mmm = calendar.get(Calendar.MONTH);
        ddd = calendar.get(Calendar.DATE);
    }

    fun changeWeight(view: View) {


        val weight = findViewById<TextView>(R.id.textViewAGE);
        weight.text = "Your Weight";
    }
}