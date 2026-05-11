create or replace procedure A(
    p_sid in number,
    p_tid in number
    )
IS
    res_ratio number;
BEGIN
    select (count(r.customer_id) / s.seat_count * 100) into res_ratio 
    from screen s join reservation r on s.theater_id = r.theater_id and s.screen_id = r.screen_id
    where s.theater_id = p_tid and s.screen_id = p_sid
    group by s.seat_count;
    dbms_output.put_line(res_ratio);
EXCEPTION
    when others then
        dbms_output.PUT_LINE('¿À·ù : ' || SQLERRM);
        
end A;
/