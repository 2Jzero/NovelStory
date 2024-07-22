<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script type="text/javascript">
    window.onload = function() {
        Swal.fire({
            title: '소장 실패',
            text: '보유하신 포인트가 부족합니다! 충전 후 시도해주세요.',
            icon: 'question',
            confirmButtonText: '확인'
        }).then(function() {
            history.back();
        });
    }
</script>