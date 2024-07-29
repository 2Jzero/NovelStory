package com.novelstory.mapper;

import java.util.ArrayList;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.novelstory.model.EpisodeTO;
import com.novelstory.model.NovelListTO;

@Mapper
public interface EpisodeMapperInter {

	/* 선택한 소설의 회차 접근 */
	ArrayList<EpisodeTO> viewEpisode(String nvId);
	
	/* 선택한 회차의 정보 */
	EpisodeTO specificEpisode(String nvId, String EPISODE);
	
	// 구매 상태 여부 변경 로직
	int isPurchased(String isPurchased, String nvId, String EPISODE);
		
	// 이전글, 다음글
	Map<String, Object> epMove(String nvId, int EP_NUM);
	
	// 소설의 마지막화
	int epNumMax(String nvId);
	
	
	// 회차 더미 데이터
	//int insertData(EpisodeTO epTO);
	
}
