//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
    
    public func convert(_ to: String) -> Money {
        var newMoney = Money(amount: amount, currency: currency)
    if currency == "USD" {
        if to == "GBP" {
            newMoney.amount = newMoney.amount/2
        } else if to == "CAN" {
            newMoney.amount = newMoney.amount * 5 / 4
        } else if to == "EUR" {
            newMoney.amount = newMoney.amount * 3 / 2
        }
    } else if currency == "GBP" {
        if to == "USD" {
            newMoney.amount = newMoney.amount * 2
        } else if to == "CAN" {
            newMoney.amount = newMoney.amount * 2 * 5 / 4
        } else if to == "EUR" {
            newMoney.amount = newMoney.amount * 2 * 3 / 2
        }
    } else if currency == "EUR" {
        if to == "USD" {
            newMoney.amount = newMoney.amount * 2 / 3
        } else if to == "GBP" {
            newMoney.amount = newMoney.amount * 2 * 5 / 4
        } else if to == "CAN" {
            newMoney.amount = newMoney.amount * 2 * 3 / 2
        }
    } else if currency == "CAN" {
        if to == "USD" {
            newMoney.amount = newMoney.amount * 4 / 5
        } else if to == "GBP" {
            newMoney.amount = newMoney.amount * 4 / 5 / 2
        } else if to == "EUR" {
            newMoney.amount = newMoney.amount * 4 / 5 * 3 / 2
        }
    } else {
        print("This currency type is not recognized")
    }
        return Money(amount: newMoney.amount, currency: to)
  }
  
  public func add(_ to: Money) -> Money {
   var newMoney = Money(amount: amount, currency: currency)
    if currency == to.currency {
        newMoney.amount = newMoney.amount + to.amount
    } else {
        return newMoney.convert(to.currency).add(to)
    }
    
    return Money(amount: newMoney.amount, currency: newMoney.currency)
  }
    
  public func subtract(_ from: Money) -> Money {
    var newMoney = Money(amount: amount, currency: currency)
    if currency == from.currency {
        newMoney.amount = newMoney.amount - from.amount
    } else {
        return newMoney.convert(from.currency).add(from)
    }
    return Money(amount: newMoney.amount, currency: newMoney.currency)
  }
    
}

////////////////////////////////////
// Job


open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }

  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }

  open func calculateIncome(_ hours: Int) -> Int {
    var result: Int
    switch type {
        case .Hourly(let rate):
            result = Int(Double(hours) * rate)
        case .Salary(let yearly):
            result = yearly
    }
    return result
  }

  open func raise(_ amt : Double) {
    var resultHourly: Double
    var resultSalary: Int
    switch type {
        case .Hourly(let rate):
            resultHourly = rate + amt
            type = JobType.Hourly(resultHourly)
        case .Salary(let yearly):
            resultSalary = yearly + Int(amt)
            type = JobType.Salary(resultSalary)
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return self._job }
    set(value) {
    if age >= 16 {
        self._job = value
    }
    }
    }

  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return self._spouse }
    set(value) {
    if age >= 18 {
        self._spouse = value
    }
    }
    }

  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }

  open func toString() -> String {
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job?.title) spouse:\(spouse?.firstName)]"
  }
}

//////////////////////////////////////
//// Family
////
open class Family {
  fileprivate var members : [Person] = []

  public init(spouse1: Person, spouse2: Person) {
    members.append(spouse1)
    members.append(spouse2)
    spouse1.spouse = spouse2
    spouse2.spouse = spouse1
  }

  open func haveChild(_ child: Person) -> Bool {
    var legal = false
    for Person in members {
        if Person.age >= 21 {
            legal = true
        }
    }
    if legal {
        members.append(child)
    }
    return legal
  }

  open func householdIncome() -> Int {
    var income = 0
    for Person in members {
        if Person.job != nil {
            income += (Person.job?.calculateIncome(2000))!
        }
    }
    return income
    }
}






