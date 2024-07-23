window.onload = function() {

	// 로그인 버튼 누를 시 활성화되는 알림창
	let loginButton = document.getElementById("login");

	loginButton.addEventListener("click", function() {

		// 유저가 입력한 아이디 값
		const userId = document.getElementById("loginId").value;
		const userPw = document.getElementById("loginPw").value;

		// AJAX 요청으로 flag값 받아와서 true일 시에만 로그인 성공 시키기
		$.ajax({
			url: "loginCheck.do",
			type: "GET",
			data: {
				id: userId,
				pw: userPw
			},
			success: function(response) {
				if (response == 0) {  // 서버 응답의 flag 값이 true인 경우
					Swal.fire({
						icon: "success",
						title: "로그인 성공!",
						showConfirmButton: false,
						timer: 1000
					}).then(() => {
						window.location.href = "novelStoryLogin.do"; // 페이지 리다이렉트
					});
				} else {
					Swal.fire({
						icon: "error",
						title: "로그인 실패",
						text: "아이디 또는 비밀번호를 확인하세요.",
						showConfirmButton: true
					});
				}
			},
		});
	});
	// 로그아웃 버튼 누를 시 활성화되는 알림창 -> logout.do 매핑된 곳으로 가서 세션 제거 후 메인화면 이동
	let logoutButton = document.getElementById("logout");

	logoutButton.addEventListener("click", function() {

		// sweetalert 경고 확인창
		Swal.fire({
			title: "로그아웃 하실건가요?",
			text: "로그아웃하시려면 '로그아웃'을 클릭하세요.",
			icon: "warning",
			showCancelButton: true,
			confirmButtonColor: "#3085d6",
			cancelButtonColor: "#d33",
			confirmButtonText: "로그아웃"
		}).then((result) => {
			if (result.isConfirmed) {
				Swal.fire({
					title: "로그아웃 성공! 잠시 후 메인으로 이동합니다!",
					showConfirmButton: false, // OK 버튼을 숨김
					timer: 1000
				}).then(() => {
					window.location.href = "logout.do"; // 페이지 리다이렉트
				});
			}
		});

	});
};
