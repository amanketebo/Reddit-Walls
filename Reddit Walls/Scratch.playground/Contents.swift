enum Result<T> {
    case success(T)
    case failure(Error)
}

let result = Result.success(5)

switch result {
case .success(let number): print(number)
case .failure(let error): print(error)
}
