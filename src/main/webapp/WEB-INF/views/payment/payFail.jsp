<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script type="text/javascript">
    window.onload = function() {
        Swal.fire({
            title: '결제 실패',
            text: '충전이 실패했습니다. 다시 시도해주세요!',
            icon: 'question',
            confirmButtonText: '확인'
        }).then(function() {
        	window.location.href = "novelstorypayments.do";
        });
    }
</script>