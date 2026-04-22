# Obiettivo: Vedere quanti clienti abbiamo

## Analizziamo i clienti totali con un count


SELECT
    COUNT(*) AS total_customer
FROM
    customer_churn cc ;

# Obiettivo: Calcolare il churn rate (percentuale delle persone che vanno via)

## Analizziamo il churn rate facendo la somma di churn_flag (1=yes)/ il totale clienti *100

SELECT
    (SUM(cc.churn_flag) / COUNT(*)) * 100 churn_rate
FROM
    customer_churn cc;

#Obiettivo: Calcolare il churn rate per tipo di contratto

## Analizziamo il churn rate per contratto raggruppando per contract

SELECT
    cc.contract,
    COUNT(*) total_customers,
    SUM(cc.churn_flag) total_churn,
    (SUM(cc.churn_flag) * 100.0 / COUNT(*)) churn_rate
FROM
    customer_churn cc
GROUP BY
    cc.contract
ORDER BY
    churn_rate DESC;

#Obiettivo : Calcolare il churn rate per tenure_group

SELECT
    cc.tenure_group,
     COUNT(*) total_customer,
     sum(cc.churn_flag) total_churn,
     ( Sum(cc.churn_flag) * 100.0 / count(*) ) churn_rate
FROM
    customer_churn cc
GROUP BY
    cc.tenure_group
ORDER BY
    churn_rate DESC;

# Obiettivo: Calcolare il churn rate per metodo di pagamento

SELECT
    cc.payment_method,
       count(*) total_customer,
       SUM(cc.churn_flag) total_churn,
       (
        SUM(cc.churn_flag)* 100.0 / count(*)
    )churn_rate
FROM
    customer_churn cc
GROUP BY
    cc.payment_method
ORDER BY
    churn_rate DESC;

# Obiettivo: Calcolare il churn rate per tipo di servizio

SELECT
    cc.internet_service ,
       count(*) total_customer,
       SUM(cc.churn_flag) total_churn,
       (
        SUM(cc.churn_flag)* 100.0 / count(*)
    )churn_rate
FROM
    customer_churn cc
GROUP BY
    cc.internet_service 
ORDER BY
    churn_rate DESC;

# Obiettivo: Analizzare la relazione tra la soddisfazione cliente e il chur rate

SELECT
    s.satisfaction_score,
       COUNT(cc.customer_id) total_customer,
       sum(cc.churn_flag) total_churn,
       ( sum(cc.churn_flag)* 100.0 / count(*)) churn_rate
FROM
    customer_churn cc
JOIN status s ON
    cc.customer_id = s.customer_id
GROUP BY
    s.satisfaction_score
ORDER BY
    churn_rate DESC;

# Obiettivo: Distribuzione della spesa

SELECT
    COUNT(customer_id) AS  total_customer,
    CASE
        WHEN monthly_charges < 50 THEN "fascia bassa"
        WHEN monthly_charges BETWEEN 50 AND 100 THEN "fascia media"
        ELSE "fascia alta"
    END AS 
        "fascia"
    FROM
        customer_churn
    GROUP BY
        fascia;

#Obiettivo: Spesa media per tipo di contratto

SELECT
    cc.contract,
    round(AVG(cc.total_charges)) avg_charges
FROM
    customer_churn cc
GROUP BY
    cc.contract
ORDER BY
    avg_charges DESC;

# Obiettivo: trovare i clienti che spendono piu della media churn

SELECT
    cc.customer_id,
    cc.total_charges
FROM
    customer_churn cc
WHERE
    cc.churn_flag = 1
    AND cc.total_charges > (
        SELECT
            AVG(cc2.total_charges)
        FROM
            customer_churn cc2
        WHERE
            cc2.churn_flag = 1
    )
ORDER BY
    cc.total_charges DESC
;


# Obiettivo : Trova clienti con spesa sopra la media dei clienti che NON churnano

SELECT
    cc.customer_id ,
    cc.total_charges
FROM
    customer_churn cc
WHERE
    cc.churn_flag = 0
    AND cc.total_charges > (
        SELECT
            avg(cc2.total_charges)
        FROM customer_churn cc2              
        WHERE cc2.churn_flag = 0
    )
ORDER BY
   cc.total_charges DESC ;
   

 # Obiettivo : Trova clienti con spesa uguale al massimo
 
SELECT
    cc.customer_id
FROM
    customer_churn cc
WHERE
    cc.total_charges = (
        SELECT
            MAX(cc2.total_charges)
        FROM
            customer_churn cc2
    );

 
   # Obiettivo : Trova i contratti con churn rate sopra la media | poi prendi i clienti dentro quei contratti
   

SELECT
    cc.customer_id,
    cc.contract
FROM
    customer_churn cc
WHERE
    cc.contract IN (
        SELECT
            contract
        FROM
            customer_churn
        GROUP BY
            contract
        HAVING
            ( SUM(churn_flag) * 100.0 / COUNT(*) ) > (
                SELECT
                    AVG(contract_churn_rate)
                FROM
                    (
                        SELECT
                            ( SUM(churn_flag) * 100.0 / COUNT(*) )  contract_churn_rate
                        FROM
                            customer_churn
                        GROUP BY
                            contract
                    )  avg_rates
            )
    );
  
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
  
