document.addEventListener("DOMContentLoaded", function() {
	
	// 년
	const birthYear = document.querySelector('#birth-year')
	// option 목록 생성 여부 확인
	isYearOptionExisted = false;
	birthYear.addEventListener('focus', function () {
		// year 목록 생성되지 않았을 때 (최초 클릭 시)
	  	if(!isYearOptionExisted) {
	    	isYearOptionExisted = true
	    	
	    	for(var i = 1940; i <= 2024; i++) {
	      		// option element 생성
	      		const YearOption = document.createElement('option')
	      		YearOption.setAttribute('value', i)
	      		YearOption.innerText = i
	      		// birthYearEl의 자식 요소로 추가
	      		this.appendChild(YearOption);
	    	}
	  	}
	});
	
		// 월
	const birthMonth = document.querySelector('#birth-month')
	// option 목록 생성 여부 확인
	isMonthOptionExisted = false;
	birthMonth.addEventListener('focus', function () {
		// month 목록 생성되지 않았을 때 (최초 클릭 시)
	  	if(!isMonthOptionExisted) {
	    	isMonthOptionExisted = true
	    	
	    	for(var i = 1; i <= 12; i++) {
	      		// option element 생성
	      		const MonthOption = document.createElement('option')
	      		MonthOption.setAttribute('value', i)
	      		MonthOption.innerText = i
	      		// birthYearEl의 자식 요소로 추가
	      		this.appendChild(MonthOption);
	    	}
	  	}
	});
	
		// 일
	const birthDay = document.querySelector('#birth-day')
	// option 목록 생성 여부 확인
	isDayOptionExisted = false;
	birthDay.addEventListener('focus', function () {
		// day 목록 생성되지 않았을 때 (최초 클릭 시)
	  	if(!isDayOptionExisted) {
	    	isDayOptionExisted = true
	    	
	    	for(var i = 1; i <= 31; i++) {
	      		// option element 생성
	      		const DayOption = document.createElement('option')
	      		DayOption.setAttribute('value', i)
	      		DayOption.innerText = i
	      		// birthYearEl의 자식 요소로 추가
	      		this.appendChild(DayOption);
	    	}
	  	}
	});

});