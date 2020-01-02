//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by Ayemere  Odia  on 22/12/2019.
//  Copyright © 2019 Ayemere  Odia . All rights reserved.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTest: XCTestCase {

    let router = RouterSpy()
    
    

    func test_start_withNoQuestion_doesNotRouteToQuestion(){
        
        makeSUT(questions:[]).start()
        
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_start_oneQuestion_RouteToQuestion(){
        
        makeSUT(questions:["Q1"]).start()
        XCTAssertEqual(router.routedQuestions,["Q1"])
    }
    
    func test_start_oneQuestion_RouteToCorrectQuestion(){
      
        makeSUT(questions:["Q1"]).start()
XCTAssertEqual(router.routedQuestions,["Q1"])
    }
    
    func test_start_oneQuestion_RouteToCorrectQuestion_2(){
        
        makeSUT(questions:["Q2"]).start()
XCTAssertEqual(router.routedQuestions,["Q2"])
    }
    
    
    func test_start_twoQuestion_RoutesToFirstQuestion(){
           
         makeSUT(questions:["Q1","Q2"]).start()

           XCTAssertEqual(router.routedQuestions,["Q1"])
       }
    
    func test_start_twiceQuestion_RoutesToFirstQuestion(){
              
    makeSUT(questions:["Q1","Q2"]).start()
    makeSUT(questions:["Q1","Q2"]).start()

XCTAssertEqual(router.routedQuestions,["Q1","Q1"])
          }
    
    
    func test_start_AnswerFirstQuestion_RoutesToSecondQuestion(){
        
        let sut =     makeSUT(questions:["Q1","Q2"])
            
            sut.start()

        router.answerCallback("A1")
        
        XCTAssertEqual(router.routedQuestions,["Q1","Q2"])
    }
    
    func test_start_And_Answer_First_And_Second_Question_With_Three_Question_RoutesTo_Second_Third_Question(){
        
        let sut =     makeSUT(questions:["Q1","Q2","Q3"])
            
            sut.start()

        router.answerCallback("A1")
        router.answerCallback("A2")

        XCTAssertEqual(router.routedQuestions,["Q1","Q2","Q3"])
    }
    
    
    func test_start_AndAnswerFirstQuestion_WithOneDoesNotRoutesToAnywhere(){
           
           let sut = makeSUT(questions:["Q1"])
               
               sut.start()

           router.answerCallback("A1")
           
           XCTAssertEqual(router.routedQuestions,["Q1"])
       }
    
    
    
    func test_start_withNoQuestion_RouteToResult(){
           
           makeSUT(questions:[]).start()
           
        XCTAssertEqual(router.routedResult!,[:])
       }
    
    func test_start_And_AnswerFirstQuestion_With_One_QuestionRoutesToResult(){
           
           let sut = makeSUT(questions:["Q1"])
               sut.start()
    router.answerCallback("A1")
        XCTAssertEqual(router.routedResult!,["Q1":"A1"])
       }
    
    func test_start_And_AnswerFirstAndSecondQuestion_With_Two_QuestionsRoutesToResult(){
              
              let sut = makeSUT(questions:["Q1","Q2"])
                  sut.start()
    router.answerCallback("A1")
    router.answerCallback("A2")
        XCTAssertEqual(router.routedResult!,["Q1":"A1","Q2":"A2"])
          }
    
    
    // MARK: -
       //Factory for SUT
       
func makeSUT(questions:[String])->Flow<String,String, RouterSpy>{
           return Flow(questions:questions, router:router)
       }
    
    
    
    class RouterSpy: Router {
        
        
        
        var routedQuestion:String? = nil
        var routedQuestions:[String] = []
        var routedResult:[String:String]? = nil
        
        func routeTo(result: [String : String]) {
            routedResult = result
        }
        
        //escaping closure to hold a value
        //as you transition
        
//        var answerCallback:Router.AnswerCallBack = {_ in }
        
        var answerCallback:(String)->Void = {_ in }
        
        func routeTo(question:String, answerCallback: @escaping (String)->Void){
        routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
    }
    
    

}


