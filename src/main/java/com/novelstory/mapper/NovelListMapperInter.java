package com.novelstory.mapper;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.novelstory.model.EpisodeTO;
import com.novelstory.model.NovelListTO;

@Mapper
public interface NovelListMapperInter {

	/* 소설 리스트 크롤링 */
	int novelCrawling(NovelListTO to);
	
	/* 전체 소설 리스트 목록 */
	ArrayList<NovelListTO> novelList();
	
	/* 장르에 따른 소설 리스트 목록*/
	ArrayList<NovelListTO> categoryList(String category);
	
	/* 검색한 소설 리스트 */
    ArrayList<NovelListTO> searchNovelList(@Param("searchWord") String searchWord);
    
	/* 선택한 소설의 뷰 리스트 */
	NovelListTO novelView(String nvId);
    
	/* 선택한 소설의 회차 접근 */
	ArrayList<EpisodeTO> viewEpisode(String nvId);
	
	/* 선택한 회차의 정보 */
	EpisodeTO specificEpisode(String nvId, String EPISODE);
	
	// 구매 상태 여부 변경 로직
	int isPurchased(String isPurchased, String nvId, String EPISODE);
	
	// 회차 더미 데이터
	//int insertData(EpisodeTO epTO);
	
}
