//
//  BoardingAndDroppingListView.swift
//  swiftUiExp
//
//  Created by Shubam Vijay Yeme on 10/06/24.
//

import SwiftUI

struct BoardingAndDroppingListView: View {
    @ObservedObject var viewModel : BusServiceViewModel
    @State var textFieldText: String = ""
    @State var isPickupSelected: Bool = false
    @State var isDropSelected: Bool = false
    @State var onFirstPage: Bool = true
    var body: some View {
        VStack(spacing: 0){
            topBar()
            pickupDropSlide(isPickupSelected: $isPickupSelected, isDropSelected: $isDropSelected, onFirstPage: $onFirstPage).padding(.top,32)
            searchBar(viewModel: viewModel, text: $textFieldText, onFirstPage: $onFirstPage).padding(.top,32)
            pickupDropList(viewModel: viewModel, isPickupSelected: $isPickupSelected, isDropSelected: $isDropSelected, onFirstPage: $onFirstPage).padding(.top,16)
            SepratorLine(leading: 0, trailing: 0, topPadding: 0)
            bottomContinueBar(isPickupSelected: $isPickupSelected, isDropSelected: $isDropSelected)
            
        }.background(Color(hex: "#111111"))
    }
}

#Preview {
    BoardingAndDroppingListView(viewModel: BusServiceViewModel())
}

struct pickupDropSlide: View {
    @Binding var isPickupSelected: Bool
    @Binding var isDropSelected: Bool
    @Binding var onFirstPage: Bool
    @Namespace var nameSpace
    
    var body: some View {
        HStack(){
            RoundedRectangle(cornerRadius: 28)
                .foregroundStyle(Color.clear)
                .overlay {
                    HStack{
                        if isPickupSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.green)
                        }
                        Text("Pickup Point")
                            .foregroundStyle(onFirstPage ? Color.black : Color.white)
                            .font(.system(size: 14))
                    }
                }
                .background(content: {
                    if onFirstPage {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color.white)
                            .matchedGeometryEffect(id: "id", in: nameSpace)
                    } else  {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color(hex: "#222222"))
                            .matchedGeometryEffect(id: "idd", in: nameSpace)
                    }
                })
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        onFirstPage = true
                    }
                    
                }
            Spacer(minLength: 16)
            RoundedRectangle(cornerRadius: 28)
                .foregroundStyle(Color.clear)
                .overlay {
                    HStack{
                        if isDropSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.green)
                        }
                        Text("Drop Point")
                            .foregroundStyle(onFirstPage ? Color.white : Color.black)
                            .font(.system(size: 14))
                    }

                }
                .background(content: {
                    if !onFirstPage {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color.white)
                            .matchedGeometryEffect(id: "id", in: nameSpace)
                    }
                    else  {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color(hex: "#222222"))
                            .matchedGeometryEffect(id: "idd", in: nameSpace)
                    }
                })
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        onFirstPage = false
                    }
                    
                }
        }.frame(height: 36)
            .padding(.horizontal, 16)
    }
}

struct topBar: View {
    var body: some View {
        HStack(){
            Image(systemName: "chevron.backward")
                .resizable()
                .frame(width: 12,height: 20)
                .foregroundStyle(Color.white)
            Text("Select pickup & drop")
                .font(.system(size: 20,weight: .bold))
                .padding(.leading, 20)
                .foregroundStyle(Color.white)
            Spacer()
        }.padding(.leading, 20)
    }
}

struct searchBar: View {
    @ObservedObject var viewModel: BusServiceViewModel
    @Binding var text: String
    @Binding var onFirstPage: Bool
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .frame(height: 56)
            .padding(.horizontal,16)
            .foregroundStyle(Color(hex: "#181818"))
            .overlay {
                RoundedRectangle(cornerRadius: 12).stroke(lineWidth: 1).fill(Color(hex: "333333"))
                    .padding(.horizontal,16)
                TextField("", text: $text, prompt: Text(onFirstPage ? "Search pickup point" : "Search drop point").foregroundColor(Color(hex: "#888888")))
                    .padding(.leading,32)
                    .foregroundStyle(Color.white)
                    .onChange(of: text, { oldValue, newValue in
                        viewModel.filterPickupAndDropLocation(with: newValue, onFirstPage: onFirstPage)
                    })
//                    .onChange(of: text) { newValue in
//                        // Filter items based on the new search text
//                        
//                    }
                    .onTapGesture {
                        
                    }
                
            }
    }
}

struct pickupDropList: View {
    @ObservedObject var viewModel: BusServiceViewModel
    @Binding var isPickupSelected: Bool
    @Binding var isDropSelected: Bool
    @Binding var onFirstPage: Bool
    @State var pickupPointIndex: Int? = nil
    @State var dropPointIndex: Int? = nil
    var body: some View {
        ZStack{
            if onFirstPage {
                createPickDropList()
                    .transition(.move(edge: .leading))
            }else{
                createPickDropList()
                    .transition(.move(edge: .trailing))
            }
        }

    }
    
    @ViewBuilder
    
    func createPickDropList() -> some View {
        List(0..<(onFirstPage ? (viewModel.pickupPointList.count > 0 ? viewModel.pickupPointList.count : 0) : (viewModel.dropPointList.count > 0 ? viewModel.dropPointList.count : 0)), id: \.self){ index in
            HStack{
                Image(systemName: onFirstPage ? (pickupPointIndex != index ? "circle" : "record.circle"): (dropPointIndex != index ? "circle" : "record.circle"))
                    .foregroundStyle(Color(hex: onFirstPage ? (pickupPointIndex != index ? "#888888":  "#EF233C") : (dropPointIndex != index ? "#888888":  "#EF233C")))
                VStack(alignment: .leading){
                    Text(onFirstPage ? (viewModel.pickupPointList.count > 0 ? viewModel.pickupPointList[index].location : "") : (viewModel.dropPointList.count > 0 ? viewModel.dropPointList[index].location : ""))
                   
                        .font(.system(size: 16))
                        .foregroundStyle(.white)
                    Text(onFirstPage ? (viewModel.pickupPointList.count > 0 ? viewModel.pickupPointList[index].fullAddress : "") : (viewModel.dropPointList.count > 0 ? viewModel.dropPointList[index].fullAddress : ""))
                        .font(.system(size: 12))
                        .foregroundStyle(Color(hex: "#888888"))
                }.padding(.leading,10)
                
                Spacer()
                Text(onFirstPage ? (viewModel.pickupPointList.count > 0 ? viewModel.pickupPointList[index].time : "") : (viewModel.dropPointList.count > 0 ? viewModel.dropPointList[index].time : ""))
                    .font(.system(size: 14))
                    .foregroundStyle(.white)
                
            }
            .frame(height: 71)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        if onFirstPage{
                            if pickupPointIndex != index{
                                pickupPointIndex = index
                                isPickupSelected = true
                                onFirstPage = false
                            }
                        }else{
                            if dropPointIndex != index{
                                dropPointIndex = index
                                isDropSelected = true
                            }
                        }
                        
                    }
                    
                    
                }
                .background(Color.clear)
                .listRowSeparator(.hidden)
                .listRowBackground(Color(hex: "#111111"))
        }.listStyle(.plain)
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    viewModel.pickupPointList =  parsePickupLocations(from: viewModel.busServices.count > 0 ? viewModel.busServices[viewModel.selectedBusIndex].boardingInfo : [String]())
                    viewModel.copyPickupPointList = viewModel.pickupPointList
                    print("=======")
                   // print(viewModel.pickupPointList)
                    viewModel.dropPointList =  parseDropLocation(from: viewModel.busServices.count > 0 ? viewModel.busServices[viewModel.selectedBusIndex].droppingInfo : [String]())
                    viewModel.copyDropPointList = viewModel.dropPointList
                    print("=======")
                    print(viewModel.dropPointList)
                }
            })
    }
}



struct bottomContinueBar: View {
    @Binding var isPickupSelected: Bool
    @Binding var isDropSelected: Bool
    var body: some View {
        Rectangle()
            .frame(height: 72)
            .overlay{
                HStack{
                    VStack(alignment: .leading){
                        Text("Amount")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                        Text("number of seats")
                            .font(.system(size: 12))
                            .foregroundStyle(Color(hex: "#888888"))
                    }.padding(.leading,28)
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 140,height: 48)
                        .foregroundStyle(isPickupSelected && isDropSelected ? LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.94, green: 0.14, blue: 0.24), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.26, green: 0.14, blue: 0.67), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: -0.04, y: 0.5),
                            endPoint: UnitPoint(x: 2.17, y: 0.5)
                        ) : LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color.gray, location: 0.00)
                            ],
                            startPoint: UnitPoint(x: -0.0, y: 0.0),
                            endPoint: UnitPoint(x: 0.0, y: 0.0)
                        )
                        )
                        .overlay (){
                            Text("Continue")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color(hex: "#FEFEFE"))
                        }
                        .padding(.trailing,16)
                        .onTapGesture {
                            
                        }
                    
                }
            }    }
}


