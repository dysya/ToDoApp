//
//  ContentView.swift
//  toDo
//
//  Created by dan4 on 05.02.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var newTodo = ""
    @State private var allTodos:[TodoItem] = []
    private let todosKey = "todoKey"
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        TextField ("Add todo...", text: $newTodo)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: {
                            guard !self.newTodo.isEmpty else {return}
                            self.allTodos.append(TodoItem(todo: self.newTodo))
                            self.newTodo = ""
                            self.saveTodo()
                        }) {
                            Image(systemName: "plus").colorMultiply(.green)
                        } .padding()
                    }.padding()
                    List {
                        ForEach(allTodos) {todoItem in
                            Text(todoItem.todo)
                        }.onDelete(perform: deleteTodo)
                    }
                }
                .navigationBarTitle("Todos")
            }

        }.onAppear(perform: loadTodo)
    }
    
    private func deleteTodo(at offsets:IndexSet) {
        self.allTodos.remove(atOffsets: offsets)
        saveTodo()
    }
    
    private func loadTodo() {
        if let todoData = UserDefaults.standard.value(forKey: todosKey) as? Data {
            if let todoList = try? PropertyListDecoder().decode(Array<TodoItem>.self, from: todoData) {
                self.allTodos = todoList
            }
        }
    }
    
    private func saveTodo() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.allTodos), forKey: todosKey)
    }
}

struct TodoItem:Codable, Identifiable {
    var id = UUID()
    let todo:String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
.previewInterfaceOrientation(.portrait)
    }
}
