DECLARE
    v_count number;
    c number := 1;
BEGIN
    A(c, v_count);
    DBMS_OUTPUT.PUT_LINE(c || v_count);
END;
/