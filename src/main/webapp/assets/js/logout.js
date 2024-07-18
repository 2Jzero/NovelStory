window.onload = function() {

	// 로그인 버튼 누를 시 활성화되는 알림창
	let loginButton = document.getElementById("login");

	loginButton.addEventListener("click", function() {

		Swal.fire({
			icon: "success",
			title: "로그인 성공!",
			showConfirmButton: false,
			timer: 3000
		});
		setTimeout(function() {
			window.location.href = "novelStoryLogin.do";
		}, 3000); // 1.5초 후 페이지 이동
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
				});
				setTimeout(function() {
					window.location.href = "logout.do";
				}, 1000); // 1초 후 페이지 이동		
			}
		});

	});
};
