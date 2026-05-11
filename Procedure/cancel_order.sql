CREATE OR REPLACE PROCEDURE cancel_order (
p_order_id IN orders.order_id%TYPE
)
IS
v_status orders.status%TYPE;
BEGIN
-- 주문 상태 확인
SELECT status INTO v_status
FROM orders
WHERE order_id = p_order_id;
-- 이미 취소된 경우
IF v_status = 'CANCELLED' THEN
DBMS_OUTPUT.PUT_LINE('이미 취소된
주문입니다.');
RETURN;
END IF;
IF v_status = 'DELIVERED' THEN
DBMS_OUTPUT.PUT_LINE('배송 완료된 주문은 취소할수없습니다.');
RETURN;
END IF; -- 주문 취소 처리
UPDATE orders
SET status = 'CANCELLED', cancel_date = SYSDATE
WHERE order_id = p_order_id; -- 재고 복구
UPDATE inventory i
SET i.stock = i.stock + (
SELECT od.quantity FROM order_detail od
WHERE od.order_id = p_order_id AND od.product_id =
i.product_id
)
WHERE i.product_id IN (
SELECT product_id FROM order_detail WHERE order_id
= p_order_id
);
COMMIT;
DBMS_OUTPUT.PUT_LINE('주문 ' || p_order_id || ' 취소 완료 및 재고 복구됨');
EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('존재하지 않는 주문번호입니다.');
WHEN OTHERS THEN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);
END cancel_order;
/
--호출

set serveroutput on
exec cancel_order(20241105);