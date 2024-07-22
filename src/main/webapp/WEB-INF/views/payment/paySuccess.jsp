<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script type="text/javascript">
    window.onload = function() {
        Swal.fire({
            title: '결제 성공',
            text: '결제가 정상적으로 완료되었습니다!',
            icon: 'success',
            confirmButtonText: '확인'
        }).then(function() {
        	window.location.href = "novelstorypayments.do";
        });
    }
</script>