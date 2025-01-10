document.addEventListener("DOMContentLoaded", function() {
    let gachaButton = document.getElementById("dailyGacha");

    gachaButton.addEventListener("click", function() {
			
        const userId = sessionStorage.getItem("logId");
		
		const cookieName = "isAlreadyGaCha-" + userId;
        const isAlreadyGaCha = getCookie(cookieName); // 쿠키에서 'isAlreadyGaCha' 값을 가져옴
        console.log(userId);
        console.log(isAlreadyGaCha);
        console.log(cookieName);

        if (isAlreadyGaCha === userId) {       
            Swal.fire({
                icon: "error",
                title: "오늘 이미 포인트를 받았습니다! 내일 다시 시도해주세요.",
                showConfirmButton: false,
                timer: 1000
            }).then(() => {
                window.location.href = "novelStory.do"; // 페이지 리다이렉트
            });
        } else {
            // 쿠키가 없으면 AJAX로 서버에 데이터 전송
            $.ajax({
                url: "dailyGacha.do",
                type: "POST",
                data: {
                    sessionId: userId
                },
                success: function(response) {
					// 응답 성공시, 성공 메세지 띄움
                    Swal.fire({
                        icon: "success",
                        title: response + "p 당첨! 내일 또 이용하세요.",
                        showConfirmButton: false,
                        timer: 1000
                    });
                }
            });
        }
    });
});

// 쿠키 값을 가져오는 함수
function getCookie(name) {
    let value = "; " + document.cookie;
    let parts = value.split("; " + name + "=");
    if (parts.length === 2) return parts.pop().split(";").shift();
    return null;
}