document.addEventListener("DOMContentLoaded", function() {
	
	// 로그인 모달 변수
	let logModal = document.getElementById("logModal");
	
	// 회원가입 모달 변수
	let signModal = document.getElementById("sgModal");
		
	// 로그인 모달 접근 태그
	let logBtn = document.getElementById("loginModal");
	
	// 회원가입 모달 접근 태그
	let sgBtn = document.getElementById("signModal");
		
	// 로그인 닫기 버튼
	let logClose = document.getElementsByClassName("close")[0];
	
	// 회원가입 모달 닫기 버튼
	let sgClose = document.getElementsByClassName("close")[1];
		
	// 클릯시 로그인 모달 열기
	logBtn.onclick = function() {
		logModal.style.display = "block";
	}
		
	// close 버튼 클릭시 모달 닫기
	logClose.onclick = function() {
		logModal.style.display = "none";
	}
		
	// 클릯시 모달 열기
	sgBtn.onclick = function() {
		signModal.style.display = "block";
	}
		
	// close 버튼 클릭시 모달 닫기
	sgClose.onclick = function() {
		signModal.style.display = "none";
	}

});