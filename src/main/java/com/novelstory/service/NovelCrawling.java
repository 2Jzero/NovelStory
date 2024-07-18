package com.novelstory.service;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.novelstory.mapper.NovelListMapperInter;
import com.novelstory.model.NovelListTO;

@Service("NovelCrawling")
public class NovelCrawling implements Nservice {

	@Autowired
	private NovelListMapperInter mapper;

	@Override
	public int getNovelInfoFromWEB() throws Exception {

		int res = 0;

		String baseUrl = "https://page.kakao.com/menu/10011/screen/";
		String[] category = { "Fantasy", "RoFantasy", "RealFantasy" };
		String[] categoryNum = { "91", "92", "64" };

		for (int i = 0; i < categoryNum.length; i++) {

			Document doc = Jsoup.connect(baseUrl + categoryNum[i]).get();

			Elements elements = doc.select("div.mb-4pxr.flex-col[data-t-obj]");

			for (Element element : elements) {
				String dataTObj = element.attr("data-t-obj");

				// setnum 값을 가져오기 위해 추출
				String setNum = dataTObj.split("\"setnum\":\"")[1].split("\"")[0];

				// setnum 값이 5인 경우에만 크롤링
				if ("5".equals(setNum)) {
					// 해당 요소의 링크 가져오기
					Elements linkTags = element.select("a[href^=/content/]");

					for (Element linkTag : linkTags) {

						// 해당 a href 링크로 이동
						String baseDomain = "https://page.kakao.com";
						String link = linkTag.attr("href");
						String absoluteLink = baseDomain + link;

						// 절대경로 통해서 다시 연결
						Document linkDoc = Jsoup.connect(absoluteLink).get();

						// 해당 경로에서 이미지, 타이틀, 작가이름 크롤링
						Element imageElements = linkDoc.selectFirst("meta[property=og:image]");
						Element titleElements = linkDoc.selectFirst("meta[property=og:title]");
						Element writerElements = linkDoc.selectFirst("meta[name=author]");

						// 변수에 넣어 저장
						String imageUrl = imageElements.attr("content");
						String title = titleElements.attr("content");
						String writer = writerElements.attr("content");

						// DB에 저장하기 위해 TO에 저장
						NovelListTO nvTO = new NovelListTO();
						nvTO.setCategory(category[i]);
						nvTO.setNvtitle(title);
						nvTO.setNvwriter(writer);
						nvTO.setImageurl(imageUrl);

						res += mapper.novelCrawling(nvTO);
					}
				}
			}
		}

		return res;
	}
}