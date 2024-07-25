// 버튼에 따라 카테고리 별 리스트를 리로드 없이 가져올 수 있게 동적 ajax 구현
$(document).ready(function() {
	// 카테고리 버튼 클릭 시 Ajax 요청 보내기
	$(".btn-container button").click(function(event) {

		// 클릭된 버튼의 name 값
		let category = $(this).attr("name");

		$.ajax({
			url: "/novelStory.do",
			type: "GET",
			data: {
				"category": category
			},
			success: function(data) {

				// 기존 카드 리스트를 지우고 카테고리에 의한 리스트 생성(중복 방지)
				updateCardContainer(data);

			},
			error: function(error) {

				// 오류 처리
				console.error("Error: " + error);
			}
		});
	});

	// 카드 컨테이너를 업데이트하는 함수
	function updateCardContainer(data) {

		// 받은 데이터로부터 카드 HTML을 생성
		let newCards = $(data).find('.card');

		// 기존의 카드들을 모두 삭제하고 새로운 카드들을 추가(sbHtml이 중복될 것을 방지하기 위해 싹 비우고 업데이트)
		$(".card-container").empty().append(newCards);
	}
});