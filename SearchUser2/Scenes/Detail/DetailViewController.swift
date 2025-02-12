//
//  DetailViewController.swift
//  SearchUser2
//
//  Created by Leojin on 2/12/25.
//

import UIKit
import Kingfisher

protocol DetailDisplayLogic: AnyObject {
    func displayAddFavorite(viewModel: API.AddFavorite.ViewModel)
    func displayRemoveFavorite(viewModel: API.RemoveFavorite.ViewModel)
}

class DetailViewController: BaseViewController, DetailDisplayLogic {
    
    //var router: DetailRoutingLogic?
    //var router: (NSObjectProtocol & ShowOrderRoutingLogic & ShowOrderDataPassing)?
    var interactor: DetailBusinessLogic?
    var router: (DetailRoutingLogic & DetailDataPassing)?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var favImageView: UIImageView!
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setup()
//        initUI()
//    }
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    private func setup() {
        let viewController = self
        let interactor = DetailInteractor()
        let presenter = DetailPresenter()
        let router = DetailRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    private func initUI() {
        
        if let item = router?.dataStore?.item {
            imageView.kf.setImage(with: URL(string: item.profileUrl),
                                         placeholder: nil,
                                         options: [.transition(.fade(0.5))],
                                         progressBlock: nil)
            descLabel.text = "\(item.name)"
            favImageView.image = UIImage(resource: (item.favorite) ? .starBlue : .star)
        }
    }
    
    private func updateUI() {
        if let item = router?.dataStore?.item {
            let localWorker = LocalWorker(localStore: LocalStore())
            let isFavorite = localWorker.isFavorite(item.id, name: item.name)
            favImageView.image = UIImage(resource: (isFavorite) ? .starBlue : .star)
        }
    }
    
    @IBAction func onClose(_ sender: Any) {
        router?.routeDismiss()
    }
    
    @IBAction func onFavorite(_ sender: Any) {
        if let item = router?.dataStore?.item {
            if item.favorite {
                interactor?.removeFavorite(request: .init(id: item.id, name: item.name))
            } else {
                interactor?.addFavorite(request: .init(id: item.id, name: item.name, profileUrl: item.profileUrl))
            }
        }
    }
    
    func displayAddFavorite(viewModel: API.AddFavorite.ViewModel) {
        updateUI()
    }
    
    func displayRemoveFavorite(viewModel: API.RemoveFavorite.ViewModel) {
        updateUI()
    }
}
