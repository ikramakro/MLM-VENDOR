import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/Album1_Model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/media_model.dart';
import '../../../repositories/e_provider_repository.dart';

class AlbumViewController extends GetxController {
  final eProvider = EProvider().obs;
  final album = <AlbumModel1>[].obs;
  final isDeletable = false.obs;
  final isDeletablePortfolio = false.obs;
  final isEditable = false.obs;
  final itemList = <AlbumModel1>[].obs;
  final selectedList = <AlbumModel1>[].obs;
  final selectedListPortfolio = <Media>[].obs;
  EProviderRepository _eProviderRepository;
  final galleries = <Media>[].obs;
  final index = 0.obs;

  AlbumViewController() {
    _eProviderRepository = new EProviderRepository();
  }

  @override
  void onInit() {
    var arguments = Get.arguments as Map<String, dynamic>;
    index.value = arguments['index'];
    print("check index value ${index.value}");
    print("this is running in album");
    isEditable.value = false;
    refreshEProvider();
    super.onInit();
  }

  Future refreshEProvider({bool showMessage = false}) async {
    await getEProvider();
  }

  Future getEProvider() async {
    try {
      List<EProvider> _eProviders = [];
      _eProviders = await _eProviderRepository.getEProviders();
      eProvider.value = _eProviders[0];
      if (eProvider.value.hasData) {
        await getGalleries();
        await getPortfolio();
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> deletePortfolio() async {
    try {
      for (int i = 0; i < selectedListPortfolio.length; i++) {
        print("selected list portfolio");
        print(selectedListPortfolio[i].id);
        await _eProviderRepository
            .deletePortfolioImage(selectedListPortfolio[i].id);
      }
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Image SuccessFully Removed"));
      await getPortfolio();

      // Get.back(closeOverlays: true);
      // Get.offNamed(Routes.PortfolioAlbumView, preventDuplicates: false);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getGalleries() async {
    print("this is gallery api running");
    try {
      album.value = [];
      final _Album = await _eProviderRepository.getAlbum(eProvider.value.id);
      if (_Album.isNotEmpty) {
        for (int i = 0; i < _Album.length; i++) {
          if (_Album[i].images.isNotEmpty) {
            album.add(_Album[i]);
            print(_Album[i]);
          }
        }
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getPortfolio() async {
    try {
      final _galleries =
          await _eProviderRepository.getGalleries(eProvider.value.id);
      galleries.assignAll(_galleries.map((e) {
        e.image.name = e.description;
        e.image.id = e.id;
        return e.image;
      }));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future delAlbum() async {
    try {
      for (int i = 0; i < selectedList.length; i++) {
        print("check this del items ${selectedList[i].images[0].albums_id} ");
        await _eProviderRepository
            .delAlbum(selectedList[i].images[0].albums_id);
      }

      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Album SuccessFully deleted"));

      await getGalleries();
      selectedList.value = [];

      // }));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
