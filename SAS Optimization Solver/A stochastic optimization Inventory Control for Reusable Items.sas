proc optmodel;
    **Sets;
    set <num> buyer = {1..2}; * buyer index;
    set <num> product = {1..3}; * product index;

    * ======================================================;

    **Parameters;
    *Fixed ordering cost of supplier per order of reusable product k from buyer j;
    num OCS{buyer, product} = [ 1602  1760  1740
                                1591  1437  1876]; 
    *Fixed ordering cost of reusable product k for buyer j;
    num OCU{buyer, product} = [ 1360  1350  1552
                                1641  1835  1736]; 
    *Fixed recovery cost of recoverable product k for buyer j;
    num OCR{buyer, product} = [ 85 97 94
                                85 87 84]; 
    *Purchasing cost per unit of reusable product k;
    num PC{product} = [20  16 17];
    num MU_PC{product} = [20 16 17];
    num SIGMA_PC{product} = [2  1 1];
    *Recovery cost per unit of recoverable product k for buyer j;
    num RC{buyer, product} = [ 20  16 17
                               17 23 22]; 
    *The holding cost of usable product k per unit for buyer j in each period;
    num HCU{buyer, product} = [1 1 1
                               1 1 1]; 
    num MU_HCU{buyer, product} = [ 1 1 1
                                   1 1 1]; 
    num SIGMA_HCU{buyer, product} = [0.16 0.11  0.10
                                     0.16  0.19  0.16]; 
    *The holding cost of recoverable product k per unit for buyer j in each period;
    num HCR{buyer, product} = [6 9 6
                               8 9 7];
    num MU_HCR{buyer, product} = [6 9 6
                                  8 9 7];
    num SIGMA_HCR{buyer, product} = [0.66 0.97  0.67
                                     0.88  0.92  0.73]; 
    *The demand rate of reusable product k for buyer j in each period;
    num D{buyer, product} = [12655  10023 10813
                             12319 13634 11438];
    num MU_D{buyer, product} = [12655 10023 10813
                                12319 13634 11438];
    num SIGMA_D{buyer, product} = [1265.5 1002.3  1081.3
                                   1231.9  1363.4  1143.8];
    *The maximum numbers that reusable product k can be reused and recovered;
    num m{product} = [1 2 3];
    *The required warehouse space for storing of reusable product k;
    num f{product} = [1 1 1];
    num MU_f{product} = [1  1 1];
    num SIGMA_f{product} = [0.12  0.18  0.14];
    *Total available budget of buyer j;
    num B{buyer} = [301797155  305944238];
    num MU_B{buyer} = [301797155  305944238];
    num SIGMA_B{buyer} = [30179715.5  30594423.8];
    *Total allowable holding cost for usable products of buyer j;
    num AHU{buyer} = [413191 401773];
    num MU_AHU{buyer} = [413191 401773];
    num SIGMA_AHU{buyer} = [41319 40177];
    *Total allowable holding cost for recoverable products j;
    num AHR{buyer} = [2031992 2051505];
    num MU_AHR{buyer} = [2031992 2051505];
    num SIGMA_AHR{buyer} = [203199 205150];
    *Total warehouse space of buyer j for usable products;
    num WSU{buyer} = [21348 21168];
    num MU_WSU{buyer} = [21348 21168];
    num SIGMA_WSU{buyer} = [2134 2116];
    *Total warehouse space of buyer j for recoverable products;
    num WSR{buyer} = [21699 21237];
    num MU_WSR{buyer} = [21699 21237];
    num SIGMA_WSR{buyer} = [2169 2123];
    *Total warehouse space of supplier;
    num WS = 50000;
    num MU_WS = 50000;
    num SIGMA_WS = 5000;
    *Total allowable number of orders for all products;
    num N = 30000;
    num MU_N = 30000;
    num SIGMA_N = 3000;
    * The probability of violating each of the constraints;
    num z_alpha = 1.96;

    * ======================================================;

    **Decision variables;
    * The economic reuse and recovery quantity for reusable product k of buyer j per cycle;
    var q{buyer, product} >= 0;
    * The ratio of economic order quantity to economic reuse and recovery quantity for reusable product k of buyer j per cycle;
    var p{buyer, product} >= 0;


    * ======================================================;

    /* minimize the total cost of buyer j */
    minimize Cost = 0.0001 *(sum{j in buyer, k in product}PC[k]*D[j,k]/(m[k]+1) + 
                    sum{j in buyer, k in product}OCU[j,k]*D[j,k]/((m[k]+1)*p[j,k]*q[j,k]) +
                    sum{j in buyer, k in product}OCR[j,k]*D[j,k]*m[k]/(m[k]+1) +
                    sum{j in buyer, k in product}RC[j,k]*D[j,k]*m[k]/((m[k]+1)*q[j,k]) +
                    sum{j in buyer, k in product}HCU[j,k]*p[j,k]*q[j,k]/(2) +
                    sum{j in buyer, k in product}HCR[j,k]*m[k]*q[j,k]/(2*(m[k]+1))+
                    sum{j in buyer, k in product}OCS[j,k]*D[j,k]/((m[k]+1)*p[j,k]*q[j,k])); *single supplier;
    * NOTE: We times the objective function to 0.0001 in order to avoid arithmetic overflow error,
                    this will not affect the optimum solution;
    * ======================================================;

    ** subject to;
    *Total available budget of buyer j; 
    con BUDGET{j in buyer}: sum{k in product}MU_PC[k]*p[j,k]*q[j,k] + z_alpha*SQRT(sum{k in product}(SIGMA_PC[k]*p[j,k]*q[j,k])^2+SIGMA_B[j]^2) <= MU_B[j];
    *Total warehouse space of usable items (supplier);
    con SUPPLIER_SPACE: sum{j in buyer, k in product}MU_f[k]*p[j,k]*q[j,k] + z_alpha*SQRT(sum{j in buyer, k in product}(SIGMA_f[k]*p[j,k]*q[j,k])^2+SIGMA_WS^2) <= MU_WS;
    *Total warehouse space of usable items (buyer); 
    con BUYER_SPACE_USABLE{j in buyer}: sum{k in product}MU_f[k]*p[j,k]*q[j,k] + z_alpha*SQRT(sum{k in product}(SIGMA_f[k]*p[j,k]*q[j,k])^2+SIGMA_WSU[j]^2) <= MU_WSU[j];
    *Total warehouse space of recoverable items (buyer); 
    con BUYER_SPACE_RECOVERED{j in buyer}: sum{k in product}MU_f[k]*q[j,k] + z_alpha*SQRT(sum{k in product}(SIGMA_f[k]*q[j,k])^2+SIGMA_WSR[j]^2) <= MU_WSR[j];
    *Total holding cost of usable items (buyer); 
    con BUYER_HOLDING_USABLE{j in buyer}: sum{k in product}MU_HCU[j,k]*p[j,k]*q[j,k]/2 + z_alpha*SQRT(sum{k in product}(SIGMA_HCU[j,k]*p[j,k]*q[j,k]/2)^2+SIGMA_AHU[j]^2) <= MU_AHU[j];
    *Total holding cost of recoverable items (buyer); 
    con BUYER_HOLDING_RECOVERED{j in buyer}: sum{k in product}MU_HCR[j,k]*m[k]*q[j,k]/(2*(m[k]+1)) + z_alpha*SQRT(sum{k in product}(SIGMA_HCR[j,k]*m[k]*q[j,k]/(2*(m[k]+1)))^2+SIGMA_AHR[j]^2) <= MU_AHR[j];
    *Total allowable number of orders;
    con ORDERS: sum{j in buyer, k in product}MU_D[j,k]/((m[k]+1)*p[j,k]*q[j,k]) + z_alpha*SQRT(sum{j in buyer, k in product}(SIGMA_D[j,k]/((m[k]+1)*p[j,k]*q[j,k]))^2+SIGMA_N^2) <= MU_N;

    solve with sqp;

    /* print the optimal solution */
    print q;
    print p;


