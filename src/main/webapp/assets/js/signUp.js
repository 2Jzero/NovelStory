// 정규 표현식(Regular Expression) 객체, 문자와 숫자로만 구성, 길이는 6 ~ 12 사이
const idRegExp = /^[a-z0-9]{6,12}$/;
	
// 영문 숫자 특수기호 조합 8자리 이상
const passRegExp = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,15}$/;
	
// 아이디에 한글 안들어가게 하기위한 한글 정규식
const koreanRegExp = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/; 

// 휴대전화번호 정규식
const phoneRegExp = /^010\d{8}$/;

$(document).ready(function() {
	$('#signOk').click(function() {

		// 아이디
		const idBox = document.getElementById('signId'); // idBox에 입력된 id값을 넣어줌.

		if (idBox.value.trim() == '') {
			Swal.fire('아이디를 입력해주세요.');
			return false;
        } else if (koreanRegExp.test(idBox.value)) {
            Swal.fire('아이디에 한글이 포함될 수 없습니다.')
            return false;
        } else if (!idRegExp.test(idBox.value)) {
            Swal.fire('아이디를 영(소)문자 / 영(소)문자와 숫자로 6 ~ 12자 사이로 작성해주세요.');
            return false;
        }	
        		
		// 비밀번호
		const passBox = document.getElementById('signPw');
		
		if(passBox.value.trim() == '') {
			Swal.fire('비밀번호를 입력해주세요.');
			return false;
		} else if(!passRegExp.test(passBox.value)) {
			Swal.fire('비밀번호를 영문 숫자 특수기호 조합 8자리 이상 입력해주세요.');
			return false;
		}
		
		
		// 생년월일
		const yearSelect = $('#birth-year').val();
		const monthSelect = $('#birth-month').val()
		const daySelect = $('#birth-day').val()

		if (yearSelect == null) {
			Swal.fire('년도를 선택해주세요.');
			return false;
		} else if (monthSelect == null) {
			Swal.fire('월을 선택해주세요.');
			return false;
		} else if (daySelect == null) {
			Swal.fire('일을 선택해주세요.');
			return false;
		} 
		
		// 전화번호
		const phoneBox = document.getElementById('signPhone');
		
		if(phoneBox.value.trim() == '') {
			Swal.fire('전화번호를 입력해주세요.');
			return false;
		} else if(!phoneRegExp.test(phoneBox.value)) {
			Swal.fire('정확하게 입력해주세요! 예) 010-1234-5678 ');
			return false;
		}
		
		
		//인증번호
		const codeBox = document.getElementById('signCode');

		if(codeBox.value.trim() == '') {
			Swal.fire('인증번호를 입력해주세요.');
			return false;
		// 전송된 인증번호를 입력하지 않을 경우를 대비
		} else if ($('#signOk').data('verified') != true) {
            Swal.fire('정확한 인증번호를 입력해주세요!');
            return false;
        }
        
        //모든 것을 충족시켰을 때 가입 성공
		document.nfrm.submit();

	});
});



// 회원가입시 입력한 휴대폰으로 인증번호 전송 후 확인 ajax 구현
$(document).ready(function() {
	$('#codeBtn').click(function() {
		let phone = $('#signPhone').val();
		
		if(phone == '') {
			Swal.fire('휴대폰 번호를 입력해주세요!');
			return false;
		} else if(!phoneRegExp.test(phone)) {
			Swal.fire('정확하게 입력해주세요! 예) 010-1234-5678 ');
			return false;
		} else {
			Swal.fire('인증번호 발송 완료!')
		}

        $('#checkBtn').prop('disabled', false);
        $('#checkBtn').removeClass('button-disabled');
        
		$.ajax({
			type: "GET",
			url: "/check/sendSMS",
			data: {
				"phone": phone
			},
			success: function(code) {				
				$('#checkBtn').click(function() {
					if ($.trim(code) == $('#signCode').val()) {
						Swal.fire('인증성공!');
          				$('#signOk').data('verified', true); // 인증 성공 플래그 설정

					} else {
						Swal.fire({
							icon: 'error',
							title: '인증오류',
							text: '인증번호가 올바르지 않습니다!',
						})
			            $('#signOk').data('verified', false); // 인증 실패 플래그 설정

					}
				})

			}
		})
	});
});
