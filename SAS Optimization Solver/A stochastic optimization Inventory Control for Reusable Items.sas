/*
Authored By: Amir H. Sadeghi
Authored On: 2023-01-15
Authored To: Non-linear Optimization Problem for Solving Reuseable Products

Change Logs: 

Updated By: NA
Updated on: NA
Updated to: NA
*/

proc optmodel;
    ** sets;
    set <num> buyer = {1..4}; * buyer index;
    set <num> product = {1..4}; * product index;

    ** parameters;
    *The inventory level of usable product k of buyer j;
    num ILU{buyer, product} = [0.08 -.05 -.05 -.05
                            -.05 0.16 -.02 -.02
                            -.05 -.02 0.35 0.06
                            -.05 -.02 0.06 0.35];
    *The inventory level of recoverable product k of buyer j;
    num ILR{buyer, product} = [0.08 -.05 -.05 -.05
                            -.05 0.16 -.02 -.02
                            -.05 -.02 0.35 0.06
                            -.05 -.02 0.06 0.35]; 
    *Fixed ordering cost of supplier per order of reusable product k from buyer j;
    num OCS{buyer, product} = [0.08 -.05 -.05 -.05
                            -.05 0.16 -.02 -.02
                            -.05 -.02 0.35 0.06
                            -.05 -.02 0.06 0.35]; 
    *Fixed ordering cost of reusable product k for buyer j;
    num OCU{buyer, product} = [0.08 -.05 -.05 -.05
                            -.05 0.16 -.02 -.02
                            -.05 -.02 0.35 0.06
                            -.05 -.02 0.06 0.35]; 
    *Fixed recovery cost of recoverable product k for buyer j;
    num OCR{buyer, product} = [0.08 -.05 -.05 -.05
                            -.05 0.16 -.02 -.02
                            -.05 -.02 0.35 0.06
                            -.05 -.02 0.06 0.35]; 
    *Purchasing cost per unit of reusable product k;
    num PC{product}=[0.05 -.20 0.15 0.30];
    *Recovery cost per unit of recoverable product k for buyer j;
    num RC{buyer, product} = [0.08 -.05 -.05 -.05
                            -.05 0.16 -.02 -.02
                            -.05 -.02 0.35 0.06
                            -.05 -.02 0.06 0.35]; 
    *The holding cost of usable product k per unit for buyer j in each period;
    num HCU{buyer, product} = [0.08 -.05 -.05 -.05
                            -.05 0.16 -.02 -.02
                            -.05 -.02 0.35 0.06
                            -.05 -.02 0.06 0.35]; 
    *The holding cost of recoverable product k per unit for buyer j in each period;
    num HCR{buyer, product} = [0.08 -.05 -.05 -.05
                            -.05 0.16 -.02 -.02
                            -.05 -.02 0.35 0.06
                            -.05 -.02 0.06 0.35]; 
    *The demand rate of reusable product k for buyer j in each period;
    num D{buyer, product} = [0.08 -.05 -.05 -.05
                            -.05 0.16 -.02 -.02
                            -.05 -.02 0.35 0.06
                            -.05 -.02 0.06 0.35];
    *The maximum numbers that reusable product k can be reused and recovered;
    num m{product}=[0.05 -.20 0.15 0.30];
    *The required warehouse space for storing of reusable product k;
    num f{product}=[0.05 -.20 0.15 0.30];
    *Total available budget of buyer j;
    num B{product}=[0.05 -.20 0.15 0.30];
    *Total allowable holding cost for usable products of buyer j;
    num AHU{buyer}=[0.05 -.20 0.15 0.30];



    /* let x1, x2, x3, x4 be the amount invested in each asset */
    var x{1..4} >= 0;

    num coeff{1..4, 1..4} = [0.08 -.05 -.05 -.05
                            -.05 0.16 -.02 -.02
                            -.05 -.02 0.35 0.06
                            -.05 -.02 0.06 0.35];
    num r{1..4}=[0.05 -.20 0.15 0.30];

    /* minimize the variance of the portfolio's total return */
    minimize f = sum{i in 1..4, j in 1..4}coeff[i,j]*x[i]*x[j];

    /* subject to the following constraints */
    con BUDGET: sum{i in 1..4}x[i] <= 10000;
    con GROWTH: sum{i in 1..4}r[i]*x[i] >= 1000;

    solve with qp;

    /* print the optimal solution */
    print x;
