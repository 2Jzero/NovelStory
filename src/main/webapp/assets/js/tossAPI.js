document.addEventListener("DOMContentLoaded", function() {
	const modal = document.getElementById('myModal');
	const btns = document.querySelectorAll('.btn');
	const closeBtn = document.getElementsByClassName('closeBtn')[0];

	//토스 앱키와 결제 정보
	const widgetClientKey = "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm"; // 앱키
	const customerKey = "hlwvhqXVKJa5TsLCRgBq8";  // 고객 고유 id = 나중에 세션 이용하여 담을 것
	const paymentWidget = PaymentWidget(widgetClientKey, customerKey); // 회원 결제
	const paymentMethodsWidget = paymentWidget.renderPaymentMethods(); // 결제 정보 변경


	let amount = 0;

	// 클릭한 amount 값 가져오기 위한 이벤트
	btns.forEach(btn => {
		btn.addEventListener('click', function() {
			// 문자열 null이 전달되어 문자열 값 비교 해줘야함
			amount = this.getAttribute('data-amount');
			paymentMethodsWidget.updateAmount(amount); // 변경된 amount 업데이트
			modal.style.display = 'block';
		});
	});

	closeBtn.addEventListener('click', function() {
		modal.style.display = 'none';
	});

	window.addEventListener('click', function(event) {
		if (event.target == modal) {
			modal.style.display = 'none';
		}
	});

	// 토스 정보
	const paymentMethodWidget = paymentWidget.renderPaymentMethods(
		"#payment-method", {
		value: amount
	}, {
		variantKey: "DEFAULT"
	});

	paymentWidget.renderAgreement("#agreement", {
		variantKey: "AGREEMENT"
	});

	//결제 요청 응답 처리 : 리퀘스트 파람을 이용해서 안의 결제 정보들을 컨트롤러에서 사용 가능
	document.getElementById("payment-button").addEventListener("click", function() {
		paymentWidget.requestPayment({
			amount: amount,
			orderId: "13W_pCfO4rzG9szJEcThKe",
			orderName: "노벨 스토리 코인",
			successUrl: "http://localhost:8080/success", // 성공 리다이렉트 URL
			failUrl: "http://localhost:8080/fail", // 실패 리다이렉트 URL
			customerEmail: "customer123@gmail.com",
			customerName: "김토스", // 사용자 정보 다 세션으로 가져와서 바꾸기 ㅇㅇ
			customerMobilePhone: "01012341234",
		})
			// 결제창을 띄울수 없는 에러가 발생하면 리다이렉트 URL로 에러를 받을 수 없어요.
			.catch(function(error) {
				if (error.code === 'USER_CANCEL') {
					// 결제 취소시 매핑된 fail controller로 이동
					window.location.href = 'http://localhost:8080/fail?code=USER_CANCEL&message=' + encodeURIComponent(error.message);
				} else if (error.code === 'INVALID_ORDER_NAME') {
					// 유효하지 않은 'orderName' 처리하기
				} else if (error.code === 'INVALID_ORDER_ID') {
					// 유효하지 않은 'orderId' 처리하기
				}
			});
	});
});