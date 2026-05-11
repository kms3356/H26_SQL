CREATE OR REPLACE PROCEDURE insert_member (
p_id IN members.member_id%TYPE, p_name IN members.member_name%TYPE, p_email IN members.email%TYPE
)
IS
BEGIN
INSERT INTO members (member_id, member_name, email, reg_date)
VALUES (p_id, p_name, p_email, SYSDATE);
COMMIT;
DBMS_OUTPUT.PUT_LINE(p_name || ' 회원 등록 완료!');
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
DBMS_OUTPUT.PUT_LINE('이미 존재하는 회원 ID입니다.');
WHEN OTHERS THEN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);
END insert_member;
/

--호출
set serveroutput on
exec insert_member('1001', '홍길동', 'hong@email.com');