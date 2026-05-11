CREATE OR REPLACE PROCEDURE raise_salary (
p_emp_id IN employees.employee_id%TYPE, p_rate IN NUMBER, -- 인상률 (예: 10 → 10%)
p_new_sal OUT employees.salary%TYPE
)
IS
v_current_sal employees.salary%TYPE;
BEGIN
-- 현재 급여 조회
SELECT salary INTO v_current_sal
FROM employees
WHERE employee_id = p_emp_id;
-- 급여 인상
p_new_sal := v_current_sal * (1 + p_rate / 100);
UPDATE employees
SET salary = p_new_sal
WHERE employee_id = p_emp_id;
COMMIT; 

DBMS_OUTPUT.PUT_LINE('급여 인상 완료: ' || v_current_sal ||
' → ' || p_new_sal);
EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('존재하지 않는 직원입니다.');
END raise_salary;
/
-- 호출
SET SERVEROUTPUT ON
DECLARE
v_new_salary employees.salary%TYPE;
BEGIN
raise_salary(101, 10, v_new_salary); -- 사번 101번, 10% 인상
DBMS_OUTPUT.PUT_LINE('새 급여: ' || v_new_salary);
END;
/