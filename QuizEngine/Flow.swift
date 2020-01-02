//
//  Flow.swift
//  QuizEngine
//
//  Created by Ayemere  Odia  on 22/12/2019.
//  Copyright © 2019 Ayemere  Odia . All rights reserved.
//

import Foundation
protocol Router {
    associatedtype Answer
    associatedtype Question:Hashable
    
    typealias AnswerCallBack = (Answer)->Void
    func routeTo(question:Question, answerCallback: @escaping AnswerCallBack)
    func routeTo(result:[Question:Answer])
}

class Flow<Question, Answer, R: Router> where R.Question == Question, R.Answer == Answer {
    
    private let router: R
    private let questions: [Question]
    private var result:[Question:Answer] = [:]
    init(questions: [Question],router: R){
        self.router = router
        self.questions = questions
    }
    
    func start(){
        if let firstQuestion = questions.first{
            router.routeTo(question: firstQuestion, answerCallback:routeNext(from:firstQuestion))
        }else{
            router.routeTo(result: result)
        }
    }
    
    
    private func routeNext(from question:Question)->R.AnswerCallBack{
        return{ [weak self] answer in
            if let strongSelf = self {
                strongSelf.routeNext(question: question, answer: answer)
            }
            
    }

}

    private func routeNext(question:Question, answer:Answer){
        
        if let currentQuestionIndex = questions.firstIndex(of:question){
                result[question] = answer

                if currentQuestionIndex + 1 < questions.count{
                               
        let nextQuestion = questions[currentQuestionIndex + 1]
                    router.routeTo(question:nextQuestion, answerCallback: routeNext(from:nextQuestion))
                           }else{
                               print("got it")
                   router.routeTo(result: result)
                           }
            }
           

        }
}
