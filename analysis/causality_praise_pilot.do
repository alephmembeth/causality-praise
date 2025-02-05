/* header */
version 15.1

set more off, permanently
set scheme s2mono


/* failure rates */
use "data_causality_praise_pilot", clear

gen fail_1 = .
   replace fail_1 = control1 != 6

gen fail_2 = .
   replace fail_2 = ///
      control2 == 2 | ///
      control2 == 3

gen fail = .
   replace fail = ///
      fail_1 == 1 | ///
      fail_2 == 1

drop if fail == 1


/* sample */
label define gender_lb 1 "female" ///
                       2 "other" ///
                       3 "male"
   label values gender gender_lb

sum age, detail
tab gender


/* judgment */
preserve
   sum taskalbert
   sum taskberta

   rename taskalbert task1
   rename taskberta task2

   reshape long task, i(id) j(task_new)

   rename task judgment
   rename task_new task

   label define task_lb 1 "Albert" ///
                        2 "Berta"
      label values task task_lb

   histogram judgment, percent discrete by(task, note("") graphregion(fcolor(white))) ///
      xtitle("... hat dafür gesorgt, dass genug Geld im Spendenglas ist.") ///
      xscale(range(0 7)) ///
      xlabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8") ///
      ytitle("Prozent") ///
      yscale(range(0 100))
   graph export causality_praise_pilot.pdf, replace
restore


/* Wilcoxon matched-pairs signed-rank test */
signrank taskalbert = taskberta
