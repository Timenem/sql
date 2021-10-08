task 1
select 
	t.register_id, 
	tn."DESC" as "tender_name", 
	sum(case when tr."DESC" = 'Sale' then tt.amt else 0 end) as "sales",
	sum(case when tr."DESC" = 'Return' then tt.amt else 0 end) as "returns",
	sum(tt.amt) as "total"
from transactions t 
join tran_cd tr on t.tran_cd = tr.id
join trans_tender tt on t.id = tt.tran_id
join tender tn on tn.id = tt.tnd_cd
where t.store_id = 's320' and t.bus_date >= CURRENT_DATE - 10
group by 1,2;


task 2
select 
	t.store_id, 
	date_trunc('month', t.bus_date) as "month", 
	sum(t.total_amt) as "total"
from transactions t 
where t.store_id like 'd%' and t.bus_date >= DATE_TRUNC('year', CURRENT_DATE)
group by 1,2;


task 3
select distinct on (t.register_id)
	t.store_id,
	t.register_id, 
	t.tran_time,
	t.id,
	t.tran_cd,
	t.total_amt,
	count(1) over (partition by t.register_id)
from transactions t 
where t.bus_date = CURRENT_DATE
order by t.register_id, t.tran_time desc;

task 4
select 
	t.store_id,
	t.register_id,
	sum(tt.amt) as "sum",
	count(distinct t.id) as "cnt"
from transactions t 
join trans_tender tt on t.id = tt.tran_id
join tender tn on tn.id = tt.tnd_cd
where tn."DESC" = 'GiftCard' and t.bus_date = CURRENT_DATE - 1
group by 1,2
having sum(tt.amt) < 10000;
